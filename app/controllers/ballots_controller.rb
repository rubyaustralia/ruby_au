class BallotsController < ApplicationController
  def create
    election = Election.find(params[:election_id])
    return redirect_to election_path(election), alert: "You have already voted in this election." if election.voting_completed_for?(current_user)

    create_votes
    track_ballot_submission

    redirect_to elections_path, notice: "Your vote has been saved."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to election_path(params[:election_id]), alert: "Failed to save your vote: #{e.message}"
  end

  private

  def ballot_params
    params.require(:ballot).require(:nomination_id_scores).permit!
  end

  def create_votes
    ballot_params.each do |nomination_id, score|
      vote = Vote.new(
        voter: current_user,
        votable: Nomination.find(nomination_id),
        score: score
      )
      vote.save!
    end
  end

  def track_ballot_submission
    PostHog.capture(
      distinct_id: current_user.posthog_distinct_id,
      event: 'ballot_submitted',
      properties: { nominations_count: ballot_params.to_h.size }
    )
  end
end
