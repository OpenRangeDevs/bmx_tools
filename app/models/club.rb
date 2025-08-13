class Club < ApplicationRecord
  has_one :race, dependent: :destroy
  has_many :race_activities, dependent: :destroy
  has_many :tool_permissions, dependent: :destroy
  has_many :users, through: :tool_permissions

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "must be URL-friendly (lowercase letters, numbers, and hyphens only)" }
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true
  validate :slug_cannot_change_if_has_races

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

  private

  def generate_slug
    self.slug = name.parameterize
  end

  def slug_cannot_change_if_has_races
    if slug_changed? && persisted? && race.present?
      errors.add(:slug, "cannot be changed when club has races")
    end
  end
end
