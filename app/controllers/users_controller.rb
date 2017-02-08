class UsersController < Clearance::UsersController
  def new
    @joining_member = JoiningMember.new(user: User.new)
    render "users/new"
  end

  def create
    @joining_member = JoiningMember.new(user: User.new)
    @joining_member.attributes = form_params

    if @joining_member.save
      flash[:notice] = t('.notice')
      redirect_back_or url_after_create
    else
      render "users/new"
    end
  end

  private

  def form_params
    params.require(:joining_member).permit!.to_h
  end
end
