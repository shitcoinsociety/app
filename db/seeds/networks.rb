btc_mainnet = Network::Bitcoin.find_or_initialize_by(name: "Bitcoin")

btc_mainnet.config = {
  # No xpub: the network on the real chain reads its key from the credentials.
  chain: "mainnet",
  explorer_url: "https://www.blockchain.com/explorer/transactions/btc/%{tx}"
}
btc_mainnet.save!
