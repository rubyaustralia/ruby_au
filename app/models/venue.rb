# == Schema Information
#
# Table name: venues
#
#  id              :bigint           not null, primary key
#  address         :string           not null
#  google_maps_url :string           not null
#  name            :string           not null
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Venue < ApplicationRecord
  has_many :events, class_name: "DatabaseEvent", dependent: :destroy

  validates :name, presence: true
  validates :google_maps_url, presence: true
  validates :address, presence: true
end
