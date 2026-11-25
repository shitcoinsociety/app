require "test_helper"

class DevelopmentSeedTest < ActiveSupport::TestCase
  test "development deposits are created only once and only the confirmed deposit is credited" do
    user = users(:one)
    user.update!(handle: "buhrmi")
    balance = balances(:bitcoin)

    assert_difference "Deposit.count", 2 do
      2.times { load Rails.root.join("db/seeds/development.rb") }
    end

    deposit = Deposit.find_by!(wallet: wallets(:bitcoin), tx: "development-seed-deposit", tx_idx: 0)
    assert_equal user, deposit.user
    assert_equal assets(:bitcoin), deposit.asset
    assert deposit.credited_at?
    assert_equal BigDecimal("0.125"), deposit.amount
    assert_equal BigDecimal("0.125"), balance.reload.amount

    pending = Deposit.find_by!(wallet: wallets(:bitcoin), tx: "development-seed-pending-deposit", tx_idx: 0)
    assert_equal user, pending.user
    assert_equal assets(:bitcoin), pending.asset
    assert_equal BigDecimal("0.05"), pending.amount
    assert_not pending.confirmed?
    assert_nil pending.credited_at
    assert_nil pending.block_height
  end
end
