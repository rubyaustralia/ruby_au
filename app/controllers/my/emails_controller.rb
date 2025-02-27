class My::EmailsController < My::ApplicationController
  def new
    @email = current_user.emails.new
  end

  def create
    @email = current_user.emails.new(email_params)
    if @email.save
      flash[:notice] = "Your email #{@email.email} has been added."
      redirect_to my_details_path
    else
      render :new
    end
  end

  def set_primary
    email = Email.find(params[:id])
    ActiveRecord::Base.transaction do
      current_user.emails.where(primary: true).find_each { |existing_email| existing_email.update!(primary: false) }
      email.update!(primary: true)
    end

    flash[:notice] = "Your primary email has been updated to #{email.email}"
    redirect_to my_details_path
  end

  def destroy
    email = Email.find(params[:id])
    if email.destroy
      flash[:notice] = "Your email #{email.email} has been deleted."
    else
      flash[:error] = "Your email #{email.email} failed to be deleted."
    end

    redirect_to my_details_path
  end

  private

  def email_params
    params.require(:email).permit(:email)
  end
end
