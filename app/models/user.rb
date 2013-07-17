class User < ActiveRecord::Base

  before_save :set_uid
  after_save :set_fb_data

  def self.set_fb_data(uid, name, image_url)
    $redis.hmset "fb_user:#{uid}", 'name', name, 'image_url', image_url, 'uid', uid
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :email)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image_url = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      user.save!

      user.update_fb_friends auth
    end
  end

  def update_fb_friends(auth)
    $redis.del friends_key
    facebook_user = FbGraph::User.new(auth.info.nickname, :access_token => oauth_token).fetch
    facebook_user.friends.each do |friend|
      $redis.sadd friends_key, friend.identifier
      User.set_fb_data friend.identifier, friend.name, friend.picture
    end
  end

  def friends
    fb_datas $redis.smembers(friends_key)
  end

  def following
    fb_datas $redis.smembers(follows_key)
  end

  def follow(uid)
    $redis.sadd follows_key, uid
  end

  def unfollow(uid)
    $redis.srem follows_key, uid
  end

  def following?(uid)
    $redis.sismember follows_key, uid
  end

  def set_fb_data
    User.set_fb_data uid, name, image_url
  end

  def fb_datas(uids)
    uids.map do |uid|
      $redis.hgetall("fb_user:#{uid}").merge is_follow: following?(uid)
    end.sort_by { |f| f['name'] }
  end

  def app_users
    User.where("id != #{id}").map do |user|
      user.serializable_hash(
          only: [:uid, :name, :image_url]
      ).merge(
          is_follow: following?(uid)
      )
    end.sort_by { |f| f['name'] }
  end

  def set_uid
    self.uid ||= "app#{id}"
  end

  private

  def friends_key
    "user:#{id}:friends"
  end

  def follows_key
    "user:#{id}:follows"
  end

end