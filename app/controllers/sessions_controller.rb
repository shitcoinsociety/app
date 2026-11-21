class SessionsController < ApplicationController
  def create
    email = params.require(:session).permit(:email)[:email].to_s.strip.downcase
    user = User.find_or_create_by!(email: email)
    token = user.issue_login_token!
    UserMailer.magic_login(user, token).deliver_later

    redirect_to new_user_path(magic_link_sent: true), status: :see_other
  end

  def destroy
    reset_session
    redirect_to root_path, status: :see_other, notice: "You are now signed out."
  end

  def magic_link
    user = User.consume_login_token(params[:token])
    if user
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, status: :see_other, notice: "You are now signed in."
    else
      redirect_to root_path, status: :see_other, alert: "This sign-in link is invalid or has expired."
    end
  end
end
