class Import < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :csv, :name, presence: true

  enumerize :status, in: [:uploaded, :imported], default: :uploaded
end
