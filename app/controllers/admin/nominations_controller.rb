class Admin::NominationsController < Admin::ApplicationController
  before_action :set_election, only: %i[new create destroy]
  before_action :set_nomination, only: %i[destroy]

  def new
    @nomination = Nomination.new(nominated_by: current_user)
  end

  def create
    nomination_attributes = build_nomination_attributes

    if nomination_attributes[:errors].present?
      @nomination = Nomination.new
      @nomination.errors.add(:base, nomination_attributes[:errors])
      render :new, status: :unprocessable_entity
    else
      @nomination = Nomination.new(nomination_attributes.merge(election: @election))
      return redirect_to admin_election_path(@election), notice: "Nomination was successfully created." if @nomination.save

      render :new, status: :unprocessable_content
    end
  end

  def destroy
    @nomination.destroy!
    redirect_to admin_election_path(@election), notice: "Nomination was successfully removed."
  end

  private

  def set_election
    @election = Election.find(params[:election_id])
  end

  def set_nomination
    @nomination = @election.nominations.find(params[:id])
  end

  def build_nomination_attributes
    nominated_member = Email.find_by(email: nomination_params[:member_email_address])&.user
    nominating_member = Email.find_by(email: nomination_params[:nominating_member_email_address])&.user

    errors = []
    errors << "Member not found" unless nominated_member
    errors << "Nominating member not found" unless nominating_member

    return { errors: errors.join(", ") } if errors.any?

    {
      nominee_id: nominated_member.id,
      nominated_by_id: nominating_member.id
    }
  end

  def nomination_params
    params.expect(nomination: [:member_email_address, :nominating_member_email_address])
  end
end
