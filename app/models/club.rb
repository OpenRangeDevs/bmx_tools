class Club < ApplicationRecord
  has_one :race, dependent: :destroy
  has_many :race_activities, dependent: :destroy
  has_many :tool_permissions, dependent: :destroy
  has_many :users, through: :tool_permissions
  has_many :ownership_transfers, dependent: :destroy

  # Owner relationship
  belongs_to :owner_user, class_name: "User", optional: true

  # Logo attachment with variants
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 120, 120, { crop: :centre } ]
  end

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "must be URL-friendly (lowercase letters, numbers, and hyphens only)" }
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true
  validates :website_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true
  validate :slug_cannot_change_if_has_races
  validate :logo_format_and_size

  before_validation :generate_slug, if: -> { name.present? && slug.blank? }

  # Soft delete functionality
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  default_scope { where(deleted_at: nil) }

  def deleted?
    deleted_at.present?
  end

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def restore!
    update!(deleted_at: nil)
  end

  def to_param
    slug
  end

  # Time zone helper methods
  def time_zone
    ActiveSupport::TimeZone[timezone]
  end

  def current_time
    Time.current.in_time_zone(timezone)
  end

  def time_from_now(duration)
    duration.from_now.in_time_zone(timezone)
  end

  # Ownership helper methods
  def owned_by?(user)
    owner_user == user
  end

  def has_owner?
    owner_user.present?
  end

  # Logo helper methods
  def logo_url(variant = :thumb)
    return nil unless logo.attached?
    Rails.application.routes.url_helpers.rails_blob_url(logo.variant(variant), only_path: true)
  end

  def has_logo?
    logo.attached? && logo.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end

  def slug_cannot_change_if_has_races
    if slug_changed? && persisted? && race.present?
      errors.add(:slug, "cannot be changed when club has races")
    end
  end

  def logo_format_and_size
    return unless logo.attached?

    # Check file format
    unless logo.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
      errors.add(:logo, "must be a PNG, JPG, JPEG, or WEBP image")
    end

    # Check file size (5MB max)
    if logo.byte_size > 5.megabytes
      errors.add(:logo, "must be less than 5MB in size")
    end
  end
end
