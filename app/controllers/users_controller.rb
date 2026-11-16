class UsersController < ApplicationController
  def create
    User.create!(user_params)
    flash[:notice] = "Sign up successful!"
    redirect_to after_signup_path
  end

  def show
    user = User.find_by(handle: params[:handle])
    @user = user.as_json(User::PUBLIC_JSON)
  end

  def new
    @ico_progress = 0
  end

  private

  def after_signup_path
    referer = URI.parse(inertia_referer.to_s)
    path = referer.path.to_s
    path = root_path unless path.start_with?("/") && !path.start_with?("//", "/\\")

    query = Rack::Utils.parse_nested_query(referer.query)
    "#{path}?#{query.merge("signedup" => "true").to_query}"
  rescue URI::InvalidURIError
    root_path(signedup: true)
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
