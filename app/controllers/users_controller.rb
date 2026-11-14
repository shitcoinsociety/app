class UsersController < ApplicationController
  def create
    User.create(user_params)
    flash.now[:notice] = "Sign up successful!"
    render inertia: "welcome", props: { signedup: true }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end