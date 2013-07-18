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

  def update_status
    current_user.update_attributes! status: user_params[:status]

    redirect_to '/users/home'
  end

  def following
    @tab = 'following'
    paginate_friends
  end

  def friends
    @tab = 'friends'
    paginate_friends

    finished 'go_to_friends'
  end

  def app_users
    @tab = 'app_users'
    paginate_friends
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
    params.require(:user).permit(:username, :name, :email, :password, :password_confirmation, :status)
  end

  def render_uid
    render :json => {success: true, uid: params[:uid]}
  end

  def paginate_friends
    current_page = params[:page] || 1
    @friends = current_user.send(@tab)

    @paginate_simulator = WillPaginate::Collection.new(current_page, WillPaginate.per_page, @friends.size)
    @friends = @friends.paginate(page: current_page)

    render :friends
  end
end
