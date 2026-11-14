class UserMailer < ApplicationMailer
  WELCOME_VIDEO_URL = "https://youtu.be/rjz4Vh_msMw"

  def welcome(user)
    @video_url = WELCOME_VIDEO_URL
    mail to: user.email, subject: "Welcome to Shitcoin Society"
  end
end
