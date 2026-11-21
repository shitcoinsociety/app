require "test_helper"

class NetworkTest < ActiveSupport::TestCase
  self.fixture_table_names = []

  BitcoinRpc = Struct.new(:block) do
    def getblockcount
      100
    end

    def getblockhash(height)
      { 100 => "block-hash" }.fetch(height)
    end

    def getblock(hash, verbosity)
      { [ "block-hash", 2 ] => block }.fetch([ hash, verbosity ])
    end
  end

  test "bitcoin scan records a deposit to a controlled wallet" do
    network = Network::Bitcoin.create!(name: "Bitcoin", last_scanned_height: 99)
    asset = Asset::Bitcoin.create!(network: network, name: "Bitcoin", symbol: "BTC")
    user = User.create!(email: "depositor@example.com")
    wallet = Wallet.new(user: user, asset: asset)
    wallet.define_singleton_method(:generate_address) { self.address = "our-address" }
    wallet.save!

    block = {
      "tx" => [ {
        "txid" => "transaction-id",
        "vout" => [
          { "value" => 1.0, "scriptPubKey" => { "address" => "other-address" } },
          { "value" => 0.12345678, "scriptPubKey" => { "address" => wallet.address } }
        ]
      } ]
    }
    network.rpc = BitcoinRpc.new(block)

    report = nil
    assert_difference "Deposit.count", 1 do
      report = network.scan_deposits
    end

    deposit = Deposit.last
    assert_equal user, deposit.user
    assert_equal asset, deposit.asset
    assert_equal wallet, deposit.wallet
    assert_equal "transaction-id", deposit.tx
    assert_equal 1, deposit.tx_idx
    assert_equal BigDecimal("0.12345678"), deposit.amount
    assert_equal 100, deposit.block_height
    assert_equal 1, deposit.confirmations
    assert_nil deposit.credited_at
    assert_equal 1, report[:created]
    assert_equal 100, network.reload.last_scanned_height

    mail = UserMailer.deposit_created(deposit)
    assert_equal [ user.email ], mail.to
    assert_includes mail.body.encoded, "0.12345678 BTC"
  end
end
