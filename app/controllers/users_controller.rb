class UsersController < ApplicationController

  def home
    @tab = 'home'
  end

  def following
    @tab = 'following'
    @friends = current_user.following

    render :friends
  end

  def friends
    @tab = 'friends'
    @friends = current_user.friends
    finished 'go_to_friends'
  end

  def app_users
    @tab = 'app_users'
    @friends = current_user.app_users

    render :friends
  end

  def follow
    current_user.follow params[:uid]
    render_uid
  end

  def unfollow
    current_user.unfollow params[:uid]
    render_uid
  end

  private

  def render_uid
    render :json => {success: true, uid: params[:uid]}
  end
end
