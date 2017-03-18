class JoiningMember < MemberForm
  # User Attributes
  attribute :password, String

  private

  def assign_user_params
    @user.attributes = { email: email, password: password }
  end
end
