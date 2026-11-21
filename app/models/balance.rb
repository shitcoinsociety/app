class Balance < ApplicationRecord
  def self.credit!(user, asset, delta)
    balance = user.balances.find_or_initialize_by(asset: asset)
    balance.amount = (balance.amount || 0) + delta
    balance.save!
    balance
  end
end
