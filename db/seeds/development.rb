user = User.find_by!(handle: "buhrmi")
asset = Asset::Bitcoin.find_by!(symbol: "BTC")

Deposit.transaction do
  wallet = user.wallets.find_or_create_by!(asset: asset)
  deposit = Deposit.find_or_create_by!(wallet: wallet, tx: "development-seed-deposit", tx_idx: 0) do |record|
    record.user = user
    record.asset = asset
    record.amount = BigDecimal("0.125")
    record.confirmations = Deposit::CONFIRMATIONS_NEEDED
  end
  deposit.credit!
end
