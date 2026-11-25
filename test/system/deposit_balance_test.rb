require "application_system_test_case"

class DepositBalanceTest < ApplicationSystemTestCase
  self.use_transactional_tests = false

  BitcoinRpc = Struct.new(:address, :height) do
    def getblockcount
      height
    end

    def getblockhash(block_height)
      block_height
    end

    def getblock(block_height, _verbosity)
      transactions = if block_height == 100
        [ {
          "txid" => "deposit-transaction",
          "vout" => [ { "value" => 0.125, "scriptPubKey" => { "address" => address } } ]
        } ]
      else
        []
      end
      { "tx" => transactions }
    end
  end

  setup do
    @network = networks(:bitcoin)
    @asset = assets(:bitcoin)
    @user = users(:one)
    @wallet = wallets(:bitcoin)
    @rpc = BitcoinRpc.new(@wallet.address, 100)
    @network.rpc = @rpc
  end

  teardown do
    Deposit.where(wallet: @wallet, tx: "deposit-transaction").delete_all if @wallet
  end

  test "a confirmed bitcoin deposit updates the balance" do
    visit magic_link_session_path(token: @user.issue_login_token!)
    assert_link "Log out", wait: 20
    visit balances_path
    assert_selector ".balance", text: "Bitcoin", wait: 20
    assert_selector ".balance", text: "0.0"

    @network.scan_deposits
    deposit = Deposit.find_by!(wallet: @wallet, tx: "deposit-transaction")
    assert_equal 1, deposit.confirmations
    assert_nil deposit.credited_at
    assert_equal 0, @user.balances.find_by!(asset: @asset).amount
    assert_selector ".balance", text: "0.0"

    @rpc.height = 101
    @network.scan_deposits

    assert deposit.reload.credited_at?
    assert_equal BigDecimal("0.125"), @user.balances.find_by!(asset: @asset).amount
    assert_selector ".balance", text: "0.125", wait: 10
  end

  test "a new bitcoin deposit appears in recent activity without reloading" do
    visit magic_link_session_path(token: @user.issue_login_token!)
    assert_link "Log out", wait: 20
    visit balances_path
    assert_selector ".balance", text: "Bitcoin", wait: 20
    assert_selector ".card", text: "No recent activity."
    page.execute_script("window.depositTestPage = true")

    @network.scan_deposits

    assert_selector ".card", text: "0.125 Bitcoin", wait: 10
    assert_no_selector ".card", text: "No recent activity."
    assert page.evaluate_script("window.depositTestPage")
  end
end
