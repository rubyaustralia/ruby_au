class UsersController < Clearance::UsersController
  def show
    @user = User
      .joins(:profile)
      .merge(Profile.visible_for_user(current_user))
      .includes(:profile)
      .find(params[:id])
  end

  def new
    @joining_member = JoiningMember.new(user: User.new)
    render "users/new"
  end

  def create
    @joining_member = JoiningMember.new(user: User.new)
    @joining_member.attributes = member_form_params

    if @joining_member.save
      flash[:notice] = t(".notice")
      sign_in @joining_member.user
      redirect_to just_joined_path
    else
      render "users/new"
    end
  end

  def edit
    user = User.find(params[:id])
    @editing_member = MemberForm.new(user: user)
  end

  def update
    user = User.find(params[:id])
    @editing_member = MemberForm.new(user: user)
    @editing_member.attributes = member_form_params
    if @editing_member.save
      flash[:notice] = t(".notice")
      redirect_to user_path(user)
    else
      render "users/edit"
    end
  end

  private

  def member_form_params
    params.require(:member).permit!.to_h
  end

  def user_visible?(_user)
    @user.visible? || current_user == @user
  end
end
