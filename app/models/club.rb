class Club < ApplicationRecord
  has_many :races, dependent: :destroy
  has_many :race_activities, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "must be URL-friendly (lowercase letters, numbers, and hyphens only)" }

  before_validation :generate_slug, if: -> { name.present? && slug.blank? }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
