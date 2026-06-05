class Campaigns::DeliverJob < ApplicationJob
  queue_as :default

  def perform(campaign)
    Campaigns::Send.call(campaign)
  end
end
