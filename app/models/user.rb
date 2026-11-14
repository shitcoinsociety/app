class User < ApplicationRecord
  has_secure_password

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
