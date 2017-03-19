class MemberForm
  # User Attributes
  include ActiveModel::Model
  include Virtus.model

  def initialize(user:)
    @user = user
    set_attributes_from_model
    attrs = @user.attributes.merge!(@profile.attributes)
    super(attrs)
  end

  attr_accessor :user

  # User Attributes
  attribute :email, String

  # UserProfile Attributes
  attribute :preferred_name, String
  attribute :full_name, String
  attribute :mailing_list, Boolean
  attribute :visible, Boolean

  # User Validations
  validates :user, presence: true
  # UserProfile Validations
  validates :preferred_name, :full_name, presence: true
  validates :mailing_list, :visible, inclusion: { in: [true, false] }

  validate :validate_user

  def save
    return false unless valid?

    User.transaction do
      assign_profile_params
      @user.save!
      @profile.save!
    end
  end

  private

  def assign_profile_params
    @profile.attributes = {
      full_name: full_name,
      mailing_list: mailing_list,
      preferred_name: preferred_name,
      visible: visible
    }
  end

  def assign_user_params
    @user.attributes = { email: email }
  end

  def set_attributes_from_model
    @profile = user.profile || user.build_profile
  end

  def validate_user
    assign_user_params

    promote_errors(user.errors) if user.invalid?
  end

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
