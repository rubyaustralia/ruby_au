class JoiningMember
  include ActiveModel::Model
  include Virtus.model

  def initialize(user:)
    @user = user
    set_attributes_from_model
  end

  attr_accessor :user

  # User Attributes
  attribute :email, String
  attribute :password, String

  # UserProfile Attributes
  attribute :preferred_name, String
  attribute :full_name, String
  attribute :mailing_list, Boolean

  # User Validations
  validates :user, presence: true
  # UserProfile Validations
  validates :preferred_name, :full_name, presence: true
  validates :mailing_list, inclusion: { in: [true, false] }

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

  def set_attributes_from_model
    @profile = user.profile || user.build_profile
  end

  def assign_user_params
    @user.attributes = { email: email, password: password }
  end

  def assign_profile_params
    @profile.attributes = {
      preferred_name: preferred_name,
      full_name: full_name,
      mailing_list: mailing_list
    }
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
