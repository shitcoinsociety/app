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
    assert_selector ".deposit-amount.pending", text: "+0.125", wait: 10
    find('[aria-label="Awaiting network confirmations"]').hover
    assert_selector '[role="tooltip"]', text: "Awaiting network confirmations"

    @rpc.height = 101
    @network.scan_deposits

    assert deposit.reload.credited_at?
    assert_equal BigDecimal("0.125"), @user.balances.find_by!(asset: @asset).amount
    assert_selector ".balance", text: "0.125", wait: 10
    assert_selector ".deposit-amount:not(.pending)", text: "+0.125", wait: 10
    assert_no_selector '[aria-label="Awaiting network confirmations"]'
    visit balances_path
    assert_selector ".deposit-amount:not(.pending)", text: "+0.125", wait: 20
    assert_no_selector '[aria-label="Awaiting network confirmations"]'
  end

  test "a new bitcoin deposit appears in recent activity without reloading" do
    visit magic_link_session_path(token: @user.issue_login_token!)
    assert_link "Log out", wait: 20
    visit balances_path
    assert_selector ".balance", text: "Bitcoin", wait: 20
    assert_selector ".card", text: "No recent activity."
    page.execute_script("window.depositTestPage = true")

    @network.scan_deposits

    assert_selector ".card", text: "+0.125", wait: 10
    assert_no_selector ".card", text: "No recent activity."
    assert page.evaluate_script("window.depositTestPage")
  end

  test "a pending deposit shows its status in the details" do
    @network.scan_deposits
    deposit = Deposit.find_by!(wallet: @wallet, tx: "deposit-transaction")

    visit magic_link_session_path(token: @user.issue_login_token!)
    assert_link "Log out", wait: 20
    visit deposit_path(deposit)

    assert_selector ".deposit-amount.pending", text: "+0.125"
    assert_selector "dt", text: "Transaction hash"
    assert_selector "dd", text: deposit.tx
    assert_selector "dt", text: "Confirmations", exact_text: true
    assert_selector "dt", text: "Required confirmations"
    assert_selector "dt", text: "Receiving wallet address"
    assert_selector "dd", text: @wallet.address
    assert_selector "dd.confirmations", text: "1", exact_text: true
    assert_selector "dd.required-confirmations", text: Deposit::CONFIRMATIONS_NEEDED.to_s, exact_text: true
    page.execute_script("document.querySelector('[aria-label=\"Awaiting network confirmations\"]').focus()")
    assert_selector '[role="tooltip"]', text: "Awaiting network confirmations"

    @rpc.height = 101
    @network.scan_deposits
    assert_selector ".deposit-amount:not(.pending)", text: "+0.125", wait: 10
    assert_selector "dd.confirmations", text: "2", exact_text: true, wait: 10
    assert_no_selector '[aria-label="Awaiting network confirmations"]'
  end
end
