class Race < ApplicationRecord
  belongs_to :club
  has_one :race_setting, dependent: :destroy

  validates :at_gate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :in_staging, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :at_gate_must_be_less_than_staging

  scope :active, -> { where(active: true) }

  private

  def at_gate_must_be_less_than_staging
    return unless at_gate.present? && in_staging.present?
    return unless at_gate > 0 || in_staging > 0

    if at_gate >= in_staging
      errors.add(:at_gate, "must be less than staging counter")
    end
  end
end
