class UsersController < ApplicationController
  def create
    User.create!(user_params)
    flash.now[:notice] = "Sign up successful!"
    render inertia: "welcome", props: { signedup: true }
  end

  def show
    user = User.find_by(handle: params[:handle])
    @user = user.as_json(User::PUBLIC_JSON)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
