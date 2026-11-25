class Deposit < ApplicationRecord
  PRIVATE_JSON = {
    only: [ :id, :user_id, :asset_id, :wallet_id, :amount, :confirmations, :created_at, :tx ],
    methods: [ :confirmed? ],
    include: {
      asset: Asset::JSON_OPTIONS
    }
  }

  # Confirmations after which a deposit counts as settled. A chain scan stops
  # recounting a deposit once it reaches this.
  CONFIRMATIONS_NEEDED = 2

  belongs_to :user
  belongs_to :asset
  belongs_to :wallet

  # Only on create: a scan refreshes the confirmations of a deposit it has
  # already recorded, and that recount is not a new payment to write about.
  after_create_commit :send_create_notification

  syncs_to_dexie via: :user

  def as_json_for_dexie
    as_json(PRIVATE_JSON)
  end

  # Deposits that are still counting up.
  scope :pending, -> { where(confirmations: 0...CONFIRMATIONS_NEEDED) }

  # Deposits that are deep enough to spend.
  scope :confirmed, -> { where(confirmations: CONFIRMATIONS_NEEDED..) }

  # Deposits that have not been added to a balance yet.
  scope :uncredited, -> { where(credited_at: nil) }

  # Adds every confirmed deposit that has not been credited yet to its user's
  # balance. Returns how many were credited.
  def self.credit_confirmed!
    confirmed.uncredited.to_a.each(&:credit!).size
  end

  def confirmed?
    confirmations >= CONFIRMATIONS_NEEDED
  end

  # Adds this deposit to the user's balance, once it is deep enough. Funding the
  # orders that were waiting for the money is not this class's job: the balance
  # change itself reconsiders the user's unfunded orders (see
  # Balance#reconsider_waiting_orders), so a deposit is just one way funds arrive.
  def credit!
    return if credited_at? || !confirmed?

    transaction do
      Balance.credit!(user, asset, amount)
      update!(credited_at: Time.current)
    end
  end

  private

  def send_create_notification
    return unless user.email.present?

    UserMailer.deposit_created(self).deliver_later
  end
end
