# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  score        :integer          not null
#  votable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  votable_id   :bigint           not null
#  voter_id     :bigint           not null
#
# Indexes
#
#  index_votes_on_votable                  (votable_type,votable_id)
#  index_votes_on_voter_id                 (voter_id)
#  index_votes_on_voter_id_and_votable_id  (voter_id,votable_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (voter_id => users.id)
#
require 'rails_helper'

RSpec.describe Vote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
