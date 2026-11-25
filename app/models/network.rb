# A network is a chain (Bitcoin, Tron, ...). The assets on it are the tokens,
# which is why anything chain-wide - configuration, RPC access, the height we
# have scanned up to - lives here instead of on the assets.
class Network < ApplicationRecord
  JSON_OPTIONS = {
    only: [],
    methods: [ :explorer_url ]
  }

  # A development machine and its node are both only up now and then, so the cursor is
  # often thousands of blocks behind the tip and catching up is minutes of nothing to
  # watch. A scan in development therefore never reaches back further than this.
  DEV_DEPTH = 3

  has_many :assets, dependent: :destroy
  has_many :wallets, through: :assets
  has_many :deposits, through: :assets

  scope :enabled, -> { where(enabled: true) }

  # The chain it is on, the node it is read from and the key addresses come from are all
  # deployment configuration, kept in the row (see db/seeds.rb) so the same code runs
  # against any chain without the environment saying which one.
  def chain
    config["chain"] or raise "#{name} has no chain configured"
  end

  def rpc_url
    config["rpc_url"] || credential_rpc_url ||
      raise("#{name} has no rpc_url configured")
  end

  # Where the chain's own explorer lives. Every chain writes a token's address
  # down differently - Tronscan under /#/token20/, Etherscan under /token/ - so
  # the layout is configuration too, with %{address} marking the spot.
  def explorer_url
    config["explorer_url"] or raise "#{name} has no explorer_url configured"
  end

  # A link to a contract on the chain's explorer: where someone who wants to read
  # the token rather than our copy of it has to go.
  def contract_url(contract)
    explorer_url % { address: contract }
  end

  # A network on the real chain keeps its key out of the database, so it is read
  # from the credentials the deployment holds instead.
  def xpub
    config["xpub"] || credential_xpub ||
      raise("#{name} has no xpub: set config.xpub, or networks.#{credential_name}.xpub in the credentials")
  end

  # The height of the newest block on the chain, read once at the start of a scan.
  def tip_height
    raise NotImplementedError, "#{self.class} does not implement #tip_height"
  end

  # Walks the blocks that follow `last_scanned_height`, records the deposits it finds,
  # recounts the ones still counting up and credits the confirmed ones. A chain that has
  # never been read starts at the tip: the blocks behind it are not ours to walk.
  #
  #   network.scan_deposits  # => { from: 812_340, to: 812_345, blocks: 6,
  #                          #      transactions: 842, created: 1, refreshed: 4, credited: 1 }
  def scan_deposits
    # The tip is read once per scan and reused for every block, so all the
    # confirmations in a report are measured against the same height.
    @tip_height = tip_height

    # Where the walk starts: the block after the last one scanned, or the tip itself when
    # this chain has never been read. Development caps how far back an old cursor reaches,
    # so a server started after a long downtime does not spend its first minutes in a gap
    # nothing is waiting for.
    from = last_scanned_height ? last_scanned_height + 1 : @tip_height
    from = [ from, @tip_height - DEV_DEPTH + 1 ].max if Rails.env.development?
    report = {
      from: from, to: @tip_height, blocks: 0, transactions: 0,
      created: 0, refreshed: 0, credited: 0
    }

    # An empty range when the tip has not moved since the last scan, which leaves
    # the first two counts at zero.
    from.upto(@tip_height) do |height|
      scan_block(height, report)
      report[:blocks] += 1
      advance_cursor(height)
    end
    report[:refreshed] = refresh_confirmations
    report[:credited] = credit_confirmed_deposits

    report
  end

  # What turns a payment into money: adds the deposits that are confirmed and not credited
  # yet to their users' balances and returns how many were credited.
  def credit_confirmed_deposits
    Deposit.where(asset: assets).credit_confirmed!
  end

  private

  # Reads one block and records the payments in it - outputs on a UTXO chain, token
  # transfers on an account chain. Adds what it read to the scan's report.
  def scan_block(height, report)
    raise NotImplementedError, "#{self.class} does not implement #scan_block"
  end

  def record_deposit(tx:, tx_idx:, wallet:, amount:, height:)
    deposit = deposits.find_or_initialize_by(wallet: wallet, tx: tx, tx_idx: tx_idx)
    deposit.user_id = wallet.user_id
    deposit.asset_id = wallet.asset_id
    deposit.amount = amount
    deposit.block_height = height
    deposit.confirmations = confirmations_for(height)
    return false if deposit.persisted? && !deposit.changed?

    deposit.save!
    true
  end

  def confirmations_for(height)
    @tip_height - height + 1
  end

  # Moved as each block is read rather than once at the end, so a catch-up that
  # dies halfway - the node answering 520 somewhere in the middle of it, say -
  # keeps the blocks it did walk instead of walking them again on every attempt.
  def advance_cursor(height)
    # Only ever move the cursor forward: a tip below it means we are talking to
    # a different chain, which must not make us scan the same blocks again.
    update!(last_scanned_height: height) if height > last_scanned_height.to_i
  end

  # Recounted from the block it came in, so a payment keeps gaining confirmations after
  # its block was scanned.
  #
  def refresh_confirmations
    deposits = Deposit.where(asset: assets).pending.where.not(block_height: nil)
      .where("confirmations <> ? - block_height + 1", @tip_height)
    count = 0
    deposits.find_each do |deposit|
      deposit.update!(confirmations: confirmations_for(deposit.block_height))
      count += 1
    end
    count
  end

  # Every wallet we control on this chain, by address, loaded once per scan. One address
  # can map to several wallets: every token on an account chain pays that same address.
  def wallets_by_address
    @wallets_by_address ||= wallets.group_by(&:address)
  end

  # Credentials name a network by the short name it goes by there, so the key of
  # Bitcoin mainnet lives at networks.bitcoin.mainnet.xpub.
  def credential_name
    type.demodulize.downcase
  end

  def credential_xpub
    Rails.application.credentials.dig(:networks, credential_name, chain.to_sym, :xpub)
  end

  def credential_rpc_url
    Rails.application.credentials.dig(:networks, credential_name, chain.to_sym, :rpc_url)
  end
end
