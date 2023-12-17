class User < ApplicationRecord
  # Include devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :trackable

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

    after_confirmation
  end

  protected

  def after_confirmation
    subscribe_to_lists

    if email_previously_changed? && previous_changes["email"].first.present?
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
