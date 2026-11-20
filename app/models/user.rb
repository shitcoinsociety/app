require "digest"

class User < ApplicationRecord
  LOGIN_TOKEN_TTL = 15.minutes

  PUBLIC_JSON = {
    only: [ :id, :name, :handle, :bio, :social_links, :created_at ],
    include: {
      profile_image: {}
    }
  }

  PRIVATE_JSON = {
    only: PUBLIC_JSON[:only] + [ :email ],
    include: {
      profile_image: {}
    }
  }

  has_secure_password

  has_one_attached :profile_image

  after_create_commit :save_in_mailchimp
  after_create_commit :send_welcome_email
  before_validation :ensure_password, on: :create

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.consume_login_token(token)
    return unless token.is_a?(String) && token.present?

    user = find_by(login_token_digest: Digest::SHA256.hexdigest(token))
    user if user&.consume_login_token(token)
  end

  syncs_to_dexie

  subscribed_to do |client|
    # backfill data after subscribing with dexiecable
    client.table("users").put(as_json(User::PRIVATE_JSON))
  end

  def issue_login_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(
      login_token_digest: Digest::SHA256.hexdigest(token),
      login_token_expires_at: LOGIN_TOKEN_TTL.from_now
    )
    token
  end

  def consume_login_token(token)
    return false unless token.is_a?(String) && token.present?

    token_digest = Digest::SHA256.hexdigest(token)
    with_lock do
      valid_token =
        login_token_digest.present? &&
        login_token_expires_at&.future? &&
        ActiveSupport::SecurityUtils.secure_compare(login_token_digest, token_digest)

      if valid_token
        update!(login_token_digest: nil, login_token_expires_at: nil)
        true
      else
        false
      end
    end
  end

  private

  def ensure_password
    self.password ||= SecureRandom.hex(16)
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  def save_in_mailchimp
    return unless Rails.env.production?

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
