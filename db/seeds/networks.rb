btc_mainnet = Network::Bitcoin.find_or_initialize_by(name: "Bitcoin")

btc_mainnet.config = {
  # No xpub: the network on the real chain reads its key from the credentials.
  chain: "mainnet",
  explorer_url: "https://blockchain.com/btc/address/%{address}"
}
btc_mainnet.save!
