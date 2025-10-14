class Asset < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
