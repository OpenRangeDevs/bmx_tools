class OwnershipTransfer < ApplicationRecord
  belongs_to :club
  belongs_to :from_user, class_name: "User"

  validates :to_user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  validate :to_user_email_cannot_be_from_user_email
  validate :expires_at_must_be_future, on: :create

  before_validation :generate_secure_token, on: :create
  before_validation :set_expiry_time, on: :create

  scope :pending, -> { where(completed_at: nil, cancelled_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :cancelled, -> { where.not(cancelled_at: nil) }
  scope :expired, -> { where("expires_at < ? AND completed_at IS NULL AND cancelled_at IS NULL", Time.current) }
  scope :active, -> { pending.where("expires_at > ?", Time.current) }

  def pending?
    completed_at.nil? && cancelled_at.nil? && !expired?
  end

  def completed?
    completed_at.present?
  end

  def cancelled?
    cancelled_at.present?
  end

  def expired?
    expires_at < Time.current
  end

  def active?
    pending? && !expired?
  end

  def complete!
    return false unless active?

    # Find the target user
    target_user = User.find_by(email: to_user_email)
    return false unless target_user

    ActiveRecord::Base.transaction do
      # Update club ownership
      club.update!(owner_user: target_user)

      # Mark transfer as completed
      update!(completed_at: Time.current)

      # TODO: Send confirmation emails
      # OwnershipTransferMailer.transfer_completed(self).deliver_later
    end

    true
  end

  def cancel!
    return false unless pending?

    update!(cancelled_at: Time.current)
    # TODO: Send cancellation email notification
    # OwnershipTransferMailer.transfer_cancelled(self).deliver_later
    true
  end

  def days_until_expiry
    return 0 if expired?
    ((expires_at - Time.current) / 1.day).ceil
  end

  private

  def generate_secure_token
    self.token = SecureRandom.urlsafe_base64(32)
  end

  def set_expiry_time
    self.expires_at = 72.hours.from_now
  end

  def to_user_email_cannot_be_from_user_email
    if to_user_email.present? && from_user.present? && to_user_email.downcase == from_user.email.downcase
      errors.add(:to_user_email, "cannot be the same as the current owner's email")
    end
  end

  def expires_at_must_be_future
    if expires_at.present? && expires_at <= Time.current
      errors.add(:expires_at, "must be in the future")
    end
  end
end
