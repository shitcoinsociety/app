class UsersController < ApplicationController
  def create
    User.create!(user_params)
    flash[:notice] = "Sign up successful!"
    redirect_to new_user_path(signedup: true)
  end

  def show
    user = User.find_by(handle: params[:handle])
    @user = user.as_json(User::PUBLIC_JSON)
  end

  def new
    @signedup = params[:signedup]
    @ico_progress = 0
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
