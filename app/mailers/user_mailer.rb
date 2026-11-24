class UserMailer < ApplicationMailer
  WELCOME_VIDEO_URL = "https://youtu.be/rjz4Vh_msMw"

  def welcome(user)
    @video_url = WELCOME_VIDEO_URL
    mail to: user.email, subject: "Welcome to the new era of financial degeneracy"
  end

  def magic_login(user, token)
    @magic_login_url = magic_link_session_url(token: token)
    mail to: user.email, subject: "Your Shitcoin Society sign-in link"
  end

  def deposit_created(deposit)
    @deposit = deposit
    mail to: deposit.user.email, subject: "Deposit received"
  end
end
