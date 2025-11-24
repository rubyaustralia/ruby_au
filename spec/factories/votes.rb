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
FactoryBot.define do
  factory :vote do
    score { 5 }
    association :voter, factory: :user

    trait :for_nomination do
      association :votable, factory: :nomination
    end
  end
end
