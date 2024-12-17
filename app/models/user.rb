class User < ApplicationRecord
  has_many :emails, dependent: :destroy # must be declared before devise :multi_email_authenticatable

  # Include devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :multi_email_authenticatable,
         :multi_email_confirmable,
         :multi_email_validatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable

  has_many :memberships, dependent: :destroy

  scope :unconfirmed, -> { where(confirmed_at: nil) }
  scope :old, -> { where('created_at < ?', 2.weeks.ago) }
  scope :subscribed_to_any_list, lambda {
    where(
      MailingList::LISTS.collect do |list|
        "mailing_lists->>'#{list}' = 'true'"
      end.join(" OR ")
    )
  }
  scope :committee, -> { where(committee: true) }

  attr_accessor :skip_subscriptions

  validates :full_name, presence: true
  validates :address, presence: true

  def active_for_authentication?
    super && deactivated_at.nil?
  end

  def deactivated?
    deactivated_at.present?
  end

  def save_as_confirmed!
    self.confirmed_at ||= Time.current
    save!
  end

  def update_emails
    # fetch the email attribute directly from the table
    existing_email = self.read_attribute_before_type_cast('email')
    if email == nil && existing_email != ''
      email = Email.new(email: existing_email, user: self, primary: true)
      email.skip_confirmation!
      email.save
      if email.errors.present?
        return errors
      end
      logger.info 'Email Updated!'
    else
      logger.info 'Email already exists or no email saved on record'
    end
  end

  def update_mailing_list_and_memberships(email_update: false)
    subscribe_to_lists

    if email_update
      update_mailing_list_email_addresses
    else
      set_up_mailing_list_flags
    end

    return if memberships.current.any?

    memberships.create joined_at: Time.current
  end

  private

  def set_up_mailing_list_flags
    MailingList::Setup.call self
  end

  def subscribe_to_lists
    return if skip_subscriptions

    MailingList.each do |list|
      next unless mailing_lists[list.name] == "true"

      MailingList::Subscribe.call self, list
    end
  end

  def update_mailing_list_email_addresses
    MailingList.each do |list|
      next unless mailing_lists[list.name] == "true"

      MailingList::Update.call self, list
    end
  end
end
