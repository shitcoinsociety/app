class UsersController < ApplicationController
  def show
    user = User.find_by(handle: params[:handle])
    @user = user.as_json(User::PUBLIC_JSON)
  end

  def new
  end
end
