class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login @user.username, user_params[:password]
      redirect_to root_path, :notice => 'Registration successfull'
    else
      render :action => 'new'
    end
  end

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

  def user_params
    params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
  end

  def render_uid
    render :json => {success: true, uid: params[:uid]}
  end
end
