class UsersController < ApplicationController
  def show
    user = params[:handle].present? ? User.find_by!(handle: params[:handle]) : User.find(params[:id])
    @user = user.as_json(User::PUBLIC_JSON)
  end

  def new
    @user_count = User.count
  end

  def index
    @users = User.all.as_json(User::PUBLIC_JSON)
  end
end
