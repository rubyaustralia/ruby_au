class BallotsController < ApplicationController
  def create
    create_votes
    track_ballot_submission

    redirect_to elections_path, notice: "Your vote has been created."
  end

  private

  def ballot_params
    params.require(:ballot).require(:nomination_id_scores).permit!
  end

  def create_votes
    ballot_params.each do |nomination_id, score|
      Vote.create!(
        voter: current_user,
        votable: Nomination.find(nomination_id),
        score: score,
      )
    end
  end

  def track_ballot_submission
    PostHog.capture(
      distinct_id: current_user.posthog_distinct_id,
      event: 'ballot_submitted',
      properties: { nominations_count: ballot_params.size }
    )
  end
end
