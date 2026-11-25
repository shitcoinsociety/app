require "test_helper"

class DevelopmentSeedTest < ActiveSupport::TestCase
  test "the development deposit is created and credited only once" do
    user = users(:one)
    user.update!(handle: "buhrmi")
    balance = balances(:bitcoin)

    assert_difference "Deposit.count", 1 do
      2.times { load Rails.root.join("db/seeds/development.rb") }
    end

    deposit = Deposit.find_by!(wallet: wallets(:bitcoin), tx: "development-seed-deposit", tx_idx: 0)
    assert_equal user, deposit.user
    assert_equal assets(:bitcoin), deposit.asset
    assert deposit.credited_at?
    assert_equal BigDecimal("0.125"), deposit.amount
    assert_equal BigDecimal("0.125"), balance.reload.amount
  end
end
