class My::DetailsController < My::ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    # TODO: do we need below code?
    @user.mailing_lists_will_change!

    if @user.update(user_params)
      MailingList::Apply.call(@user)

      flash[:notice] = 'Your details have been updated.'
      redirect_to my_details_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(\
      :full_name, :address, :visible,
      mailing_lists: MailingList.all.collect(&:name)
    )
  end
end
