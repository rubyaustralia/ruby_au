class Admin::NominationsController < Admin::ApplicationController
  before_action :set_election, only: %i[new create]

  def new
    @nomination = Nomination.new
  end

  def create
    @nomination = Nomination.new(build_nomination_attributes.merge(election: @election))

    if @nomination.errors.empty? && @nomination.save
      redirect_to admin_election_path(@election), notice: "Nomination was successfully created."
    else
      render :new, status: @nomination.errors.include?(:base) ? :unprocessable_entity : :unprocessable_content
    end
  end

  def destroy
    raise NotImplementedError
  end

  private

  def set_election
    @election = Election.find(params[:election_id])
  end

  def build_nomination_attributes
    nominated_member = Email.find_by(email: nomination_params[:member_email_address])&.user
    nominating_member = Email.find_by(email: nomination_params[:nominating_member_email_address])&.user

    attributes = { nominee_id: nominated_member&.id, nominated_by_id: nominating_member&.id }
    add_nomination_errors(nominated_member, nominating_member)
    attributes
  end

  def add_nomination_errors(nominated_member, nominating_member)
    @nomination = Nomination.new
    @nomination.errors.add(:base, "Member not found") unless nominated_member
    @nomination.errors.add(:base, "Nominating member not found") unless nominating_member
  end

  def nomination_params
    params.expect(nomination: [:member_email_address, :nominating_member_email_address])
  end
end
