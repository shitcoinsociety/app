class Balance < ApplicationRecord
  PRIVATE_JSON = {
    only: [ :id, :user_id, :asset_id, :amount, :available, :locked ],
    include: {
      asset: Asset::JSON_OPTIONS
    }
  }

  belongs_to :user
  belongs_to :asset
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  syncs_to_dexie via: :user

  def self.credit!(user, asset, delta)
    balance = user.balances.find_or_initialize_by(asset: asset)
    balance.amount = (balance.amount || 0) + delta
    balance.save!
    balance
  end

  def as_json_for_dexie
    as_json(PRIVATE_JSON)
  end
end
