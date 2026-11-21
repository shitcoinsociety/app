require "net/http"

# What the chain clients share: one POST to a public node, with the timeouts such
# a shared, occasionally slow node needs. What differs between the chains is how a
# request is built and what the answer means, so that stays in the subclasses.
#
# Nothing here retries. A node behind Cloudflare that answers 520 answers it for a
# while, and the scan is a poller with a schedule behind it: the blocks we could not
# read are cheaper to walk again on the next run, from the height the cursor reached
# (see Network#advance_cursor), than to sit and wait for them here.
class Network::Rpc
  OPEN_TIMEOUT = 5
  READ_TIMEOUT = 60

  def initialize(url)
    @uri = URI.parse(url)
  end

  private

  attr_reader :uri

  # Split from the callers so a test can stand in for the network; the timeouts
  # are the only reason it is not inline.
  def connect(request)
    Net::HTTP.start(
      uri.hostname, uri.port,
      use_ssl: uri.scheme == "https",
      open_timeout: OPEN_TIMEOUT,
      read_timeout: READ_TIMEOUT
    ) { |http| http.request(request) }
  end
end
