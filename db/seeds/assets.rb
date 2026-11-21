btc_network = Network::Bitcoin.find_by!(name: "Bitcoin")

btc = Asset::Bitcoin.find_or_initialize_by(symbol: "BTC", network: btc_network)
btc.name = "Bitcoin"
btc.save!
unless btc.icon.attached?
  btc.icon.attach File.open("db/seeds/assets/bitcoin.png")
end
