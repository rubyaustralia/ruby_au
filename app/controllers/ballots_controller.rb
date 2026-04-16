class BallotsController < ApplicationController
  def create
    nomination_ids = ballot_params.keys
    nominations_by_id = Nomination.where(id: nomination_ids).index_by { |nomination| nomination.id.to_s }

    ballot_params.each do |nomination_id, score|
      nomination = nominations_by_id[nomination_id.to_s]
      raise ActiveRecord::RecordNotFound, "Couldn't find Nomination with 'id'=#{nomination_id}" unless nomination

      Vote.create!(
        voter: current_user,
        votable: nomination,
        score: score,
      )
    end
  end

  private

  def ballot_params
    params.require(:ballot).require(:nomination_id_scores).permit!
  end
end
