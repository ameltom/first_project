class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates_confirmation_of :password, :message => "should match confirmation", :if => :password

  after_save :set_uid, :set_fb_data

  def self.set_fb_data(uid, name, image_url, status = nil)
    $redis.hmset "fb_user:#{uid}", 'name', name, 'image_url', image_url, 'uid', uid, 'status', status
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :email)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.username = auth.info.nickname
      user.email = auth.info.email
      user.image_url = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      user.save!

      user.update_fb_friends
    end
  end

  def update_fb_friends
    $redis.del friends_key
    facebook_user = FbGraph::User.new(username, :access_token => oauth_token).fetch
    facebook_user.friends.each do |friend|
      $redis.sadd friends_key, friend.identifier
      User.set_fb_data friend.identifier, friend.name, friend.picture
    end
  end

  def friends
    fb_datas $redis.smembers(friends_key)
  end

  def following
    fb_datas $redis.smembers(following_key)
  end

  def follow(uid)
    $redis.sadd following_key, uid
  end

  def unfollow(uid)
    $redis.srem following_key, uid
  end

  def following?(uid)
    $redis.sismember following_key, uid
  end

  def set_fb_data
    User.set_fb_data uid, name, image_url, status
  end

  def fb_datas(uids)
    uids.map do |uid|
      $redis.hgetall("fb_user:#{uid}").merge(
          is_follow: following?(uid)
      )
    end.sort_by { |f| f['name'] }
  end

  def app_users
    users = User.where("id != #{id}").order(:name)

    users.map do |user|
      user.serializable_hash(
          only: [:uid, :name, :image_url, :status]
      ).merge(
          is_follow: following?(user.uid)
      )
    end
  end

  def set_uid
    update_attributes! uid: "app#{id}" unless uid
  end

  private

  def friends_key
    "user:#{id}:friends"
  end

  def following_key
    "user:#{id}:following"
  end
end