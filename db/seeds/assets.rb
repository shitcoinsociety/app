btc_network = Network::Bitcoin.find_by!(name: "Bitcoin")

btc = Asset::Bitcoin.where(symbol: "BTC").first_or_create do |asset|
  asset.network = btc_network
  asset.name = "Bitcoin"
end
unless btc.icon.attached?
  btc.icon.attach File.open("db/seeds/assets/bitcoin.png")
end
