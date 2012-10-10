class SessionsController < ApplicationController
  before_filter :user_signed_in?, :only => [:delete]
  
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to story_boards_path, :notice => "Logged in!"
    else
      redirect_to root_url, :alert => "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:story_board_passwords] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
