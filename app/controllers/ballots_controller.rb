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

    PostHog.capture(
      distinct_id: current_user.posthog_distinct_id,
      event: 'ballot_submitted',
      properties: { nominations_count: ballot_params.size }
    )

    redirect_to elections_path, notice: "Your vote has been created."
  end

  private

  def ballot_params
    params.require(:ballot).require(:nomination_id_scores).permit!
  end
end
