class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    DailyDigest.new.send_digest
  end
end
