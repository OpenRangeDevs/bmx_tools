class Club < ApplicationRecord
  has_one :race, dependent: :destroy
  has_many :race_activities, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "must be URL-friendly (lowercase letters, numbers, and hyphens only)" }
  validates :timezone, presence: true, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  before_validation :generate_slug, if: -> { name.present? && slug.blank? }

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
end
