class User < ApplicationRecord
  PUBLIC_JSON = {
    only: [ :id, :name, :handle, :bio, :website, :created_at ],
    include: {
      profile_image: {}
    }
  }

  has_secure_password

  has_one_attached :profile_image

  after_create_commit :save_in_mailchimp
  before_validation :ensure_password, on: :create

  private

  def ensure_password
    self.password ||= SecureRandom.hex(16)
  end

  def save_in_mailchimp
    gibbon = Gibbon::Request.new(api_key: Rails.application.credentials.mailchimp.api_key)
    list_id = Rails.application.credentials.mailchimp.list_id
    gibbon.lists(list_id).members.put(
      body: {
        email_address: self.email,
        status: "subscribed"
      }
    )
  end
end
