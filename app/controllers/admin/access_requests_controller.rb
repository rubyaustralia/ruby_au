class Admin::AccessRequestsController < Admin::ApplicationController
  expose(:access_requests) do
    AccessRequest.order(created_at: :desc).page params[:page]
  end
  expose(:access_request) do
    if params[:id]
      AccessRequest.find params[:id]
    else
      AccessRequest.new access_request_params
    end
  end

  def create
    access_request.requested_on ||= Time.current.to_date
    access_request.recorder = current_user

    if access_request.save
      redirect_to admin_access_requests_path, notice: "The access request has been saved."
    else
      render :new
    end
  end

  def update
    if access_request.update access_request_params
      redirect_to admin_access_requests_path, notice: "The access request has been updated."
    else
      render :edit
    end
  end

  private

  def access_request_params
    params.fetch(:access_request, {}).permit(
      :name, :reason, :requested_on, :viewed_on
    )
  end
end
