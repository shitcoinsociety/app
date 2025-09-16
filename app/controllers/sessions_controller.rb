class SessionsController < ApplicationController
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You have been logged in!"
      redirect_to root_path
    else
      flash[:error] = "Invalid email or password"
      redirect_back
    end
  end
end
