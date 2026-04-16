class BallotsController < ApplicationController
  def create
    nominations = Nomination.where(id: ballot_params.keys).index_by { |n| n.id.to_s }

    ballot_params.each do |nomination_id, score|
      nomination = nominations[nomination_id] || raise(ActiveRecord::RecordNotFound)
      vote = Vote.find_or_initialize_by(
        voter: current_user,
        votable: nomination,
      )
      vote.score = score
      vote.save!
    end
  end

  private

  def ballot_params
    params.require(:ballot).require(:nomination_id_scores).permit!
  end
end
