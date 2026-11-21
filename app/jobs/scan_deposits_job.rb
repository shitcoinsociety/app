# Walks the blocks that follow each network's last scanned height and records
# the deposits it finds. Scheduled as a recurring task in config/recurring.yml.
class ScanDepositsJob < ApplicationJob
  limits_concurrency to: 1,
                     key: "scan_deposits_job",
                     on_conflict: :discard,
                     duration: 5.minutes

  def perform
    Network.enabled.find_each do |network|
      report = network.scan_deposits

      message = "#{network.name}: #{scanned(report)}; " \
        "#{report[:created]} new deposit(s), " \
        "#{report[:refreshed]} pending deposit(s) recounted, " \
        "#{report[:credited]} deposit(s) credited."

      # The tip usually has not moved between two runs of a 30 second schedule, and
      # an empty scan does nothing else, so it is not worth an info line.
      if report[:blocks].zero?
        Rails.logger.debug(message)
      else
        Rails.logger.info(message)
      end
    rescue StandardError => error
      # A chain we cannot read - a public node answering 520, say - must not cost
      # us the blocks of every chain that comes after it in this loop: the scan
      # picks up at the height it reached (see Network#advance_cursor), and the
      # schedule comes round again in 30 seconds. Swallowing the error is only
      # safe because this line is what is left to say it went wrong.
      Rails.logger.error("#{network.name}: scan failed, carrying on with the rest: " \
        "#{error.class}: #{error.message}")
    end
  end

  private

  def scanned(report)
    return "no new blocks, tip still at #{report[:to]}" if report[:blocks].zero?

    "scanned blocks #{report[:from]}-#{report[:to]} " \
      "(#{report[:blocks]} block(s), #{report[:transactions]} transaction(s))"
  end
end
