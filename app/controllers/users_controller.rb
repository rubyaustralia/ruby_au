class UsersController < Clearance::UsersController
  def new
    @joining_member = JoiningMember.new(user: User.new)
    render "users/new"
  end

  def show
    @user = User.includes(:profile).find(params[:id])
  end

  def edit
    user = User.find(params[:id])
    @editing_member = EditingMember.new(user: user)
  end

  def update
    user = User.find(params[:id])
    @editing_member = EditingMember.new(user: user)
    @editing_member.attributes = editing_form_params
    if @editing_member.save
      flash[:notice] = t(".notice")
      redirect_to user_path(user)
    else
      render "users/edit"
    end
  end

  def create
    @joining_member = JoiningMember.new(user: User.new)
    @joining_member.attributes = joining_form_params

    if @joining_member.save
      flash[:notice] = t(".notice")
      sign_in @joining_member.user
      redirect_to just_joined_path
    else
      render "users/new"
    end
  end

  private

  def joining_form_params
    params.require(:joining_member).permit!.to_h
  end

  def editing_form_params
    params.require(:editing_member).permit!.to_h
  end
end
