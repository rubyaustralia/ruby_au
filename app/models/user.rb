# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  address                :text
#  committee              :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deactivated_at         :datetime
#  email_confirmed        :boolean          default(FALSE)
#  encrypted_password     :string
#  full_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  linkedin_url           :string
#  mailing_list           :boolean          default(FALSE), not null
#  mailing_lists          :json             not null
#  preferred_name         :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  seeking_work           :boolean          default(FALSE), not null
#  sign_in_count          :integer          default(0), not null
#  token                  :string
#  unconfirmed_email      :string
#  visible                :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
  has_many :emails, dependent: :destroy
  has_many :access_requests, foreign_key: :recorder_id, dependent: :destroy, inverse_of: :recorder
  has_many :nominations_received, class_name: 'Nomination', foreign_key: :nominee_id, inverse_of: :nominee, dependent: :restrict_with_error
  has_many :nominations_made, class_name: 'Nomination', foreign_key: :nominated_by, inverse_of: :nominated_by, dependent: :restrict_with_error

  scope :seeking_work, -> { where(seeking_work: true).where.not(linkedin_url: [nil, ""]) }
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
  validates :linkedin_url, format: { with: %r{\Ahttps://(www\.)?linkedin\.com/.*\z}i, message: "must be a valid LinkedIn URL" }, allow_blank: true

  def primary_email
    emails.find_by(primary: true)&.email || email
  end

  def posthog_distinct_id
    email
  end

  def posthog_properties
    {
      email: email,
      full_name: full_name,
      committee: committee,
      seeking_work: seeking_work,
      date_joined: created_at&.iso8601
    }
  end

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
