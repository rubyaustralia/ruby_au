class BallotsController < ApplicationController
  def create
    ballot_params.each do |nomination_id, score|
      nomination = Nomination.find(nomination_id)

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
