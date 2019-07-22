class ImportedMember < ApplicationRecord
  scope :uncontacted, -> { where(contacted_at: nil) }
end
