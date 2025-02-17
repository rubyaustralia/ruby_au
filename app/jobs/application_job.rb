class ApplicationJob < ActiveJob::Base
  self.enqueue_after_transaction_commit = true
end
