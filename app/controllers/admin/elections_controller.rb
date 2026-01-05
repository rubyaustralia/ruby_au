class Admin::ElectionsController < Admin::ApplicationController
  before_action :set_election, only: %i[show edit update destroy]
  before_action :set_election_nominations, only: %i[show]

  def index
    @elections = Election.order(created_at: :desc)
  end

  def show; end

  def new
    @election = Election.new
  end

  def edit; end

  def create
    @election = Election.new(election_params)

    if @election.save
      redirect_to admin_election_path(@election), notice: "Election was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @election.update(election_params)
      redirect_to admin_election_path(@election), notice: "Election was successfully updated."
    else
      render :edit, status: :unprocessable_content, alert: "Election could not be updated due to #{@election.errors.full_messages.to_sentence}."
    end
  end

  def destroy
    raise NotImplementedError
  end

  private

  def set_election
    @election = Election.find(params[:id])
  end

  def set_election_nominations
    @nominations = @election.nominations
  end

  def election_params
    params.expect(election: [:closed_at, :opened_at, :point_scale, :title, :vacancies])
  end
end
