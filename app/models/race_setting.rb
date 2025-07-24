class RaceSetting < ApplicationRecord
  belongs_to :race

  validates :race, presence: true

  def notification_active?
    notification_message.present? && notification_expires_at.present? && notification_expires_at > Time.current
  end
end
