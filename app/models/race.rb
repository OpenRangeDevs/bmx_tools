class Race < ApplicationRecord
  belongs_to :club
  has_one :race_setting, dependent: :destroy
  has_many :race_activities, dependent: :destroy

  validates :at_gate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :in_staging, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :at_gate_must_be_less_than_staging

  scope :active, -> { where(active: true) }

  # Track changes for activity logging
  before_update :track_counter_changes
  
  # Broadcast updates to all connected clients for this club
  after_update_commit :broadcast_race_update
  after_update_commit :log_counter_activity

  private

  def at_gate_must_be_less_than_staging
    return unless at_gate.present? && in_staging.present?
    return unless at_gate > 0 || in_staging > 0

    if at_gate >= in_staging
      errors.add(:at_gate, "must be less than staging counter")
    end
  end

  def track_counter_changes
    @previous_at_gate = at_gate_was
    @previous_in_staging = in_staging_was
  end

  def log_counter_activity
    # Only log if counters actually changed
    if @previous_at_gate != at_gate || @previous_in_staging != in_staging
      RaceActivity.log_counter_update(
        self, 
        @previous_at_gate, 
        @previous_in_staging, 
        at_gate, 
        in_staging
      )
    end
  end

  def broadcast_race_update
    # Broadcast to the club-specific stream (for public display)
    broadcast_update_to "club_#{club.slug}", 
                       target: "race-display",
                       partial: "races/race_display", 
                       locals: { race: self, club: club }
                       
    # Also broadcast to admin pages (for multiple admin users)
    broadcast_update_to "club_#{club.slug}_admin",
                       target: "admin-counters",
                       partial: "races/admin_counters",
                       locals: { race: self, club: club }
                       
    # Update the notification panel with timestamp
    broadcast_update_to "club_#{club.slug}_admin",
                       target: "live-notifications",
                       partial: "races/live_notifications",
                       locals: { club: club, last_update: Time.current }

    # Enhanced: Broadcast validation state updates
    broadcast_update_to "club_#{club.slug}_admin",
                       target: "validation-message",
                       partial: "races/validation_message",
                       locals: { race: self }
  end
end
