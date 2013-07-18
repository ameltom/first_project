class SessionsController < ApplicationController
  skip_before_filter :require_login

  def new
    @user = User.new
  end

  def create
    if env["omniauth.auth"]
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url
    else
      if @user = login(params[:username], params[:password])
        redirect_to root_url
      else
        flash.now[:alert] = 'Login failed.'
        render :action => 'new'
      end
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
