# == Schema Information
#
# Table name: nominations
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  election_id     :bigint           not null
#  nominated_by_id :bigint           not null
#  nominee_id      :bigint           not null
#
# Indexes
#
#  index_nominations_on_election_id                 (election_id)
#  index_nominations_on_election_id_and_nominee_id  (election_id,nominee_id) UNIQUE
#  index_nominations_on_nominated_by_id             (nominated_by_id)
#  index_nominations_on_nominee_id                  (nominee_id)
#
# Foreign Keys
#
#  fk_rails_...  (election_id => elections.id)
#  fk_rails_...  (nominated_by_id => users.id)
#  fk_rails_...  (nominee_id => users.id)
#
require 'rails_helper'

RSpec.describe Nomination, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
