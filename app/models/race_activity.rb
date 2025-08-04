class RaceActivity < ApplicationRecord
  belongs_to :race
  belongs_to :club

  validates :activity_type, presence: true
  validates :message, presence: true

  scope :recent, -> { order(created_at: :desc).limit(10) }
  scope :for_club, ->(club) { where(club: club) }

  ACTIVITY_TYPES = %w[
    counter_update
    reset_performed
    settings_changed
    admin_login
    admin_logout
    notification_sent
    race_started
    race_completed
  ].freeze

  validates :activity_type, inclusion: { in: ACTIVITY_TYPES }

  # Broadcast new activity to admin users
  after_create_commit :broadcast_activity

  def self.log_counter_update(race, old_at_gate, old_in_staging, new_at_gate, new_in_staging)
    create!(
      race: race,
      club: race.club,
      activity_type: "counter_update",
      message: "Counters updated: At Gate #{old_at_gate}→#{new_at_gate}, In Staging #{old_in_staging}→#{new_in_staging}",
      metadata: {
        old_at_gate: old_at_gate,
        old_in_staging: old_in_staging,
        new_at_gate: new_at_gate,
        new_in_staging: new_in_staging
      }
    )
  end

  def self.log_reset(race, reset_type)
    create!(
      race: race,
      club: race.club,
      activity_type: "reset_performed",
      message: "Race counters reset (#{reset_type})",
      metadata: { reset_type: reset_type }
    )
  end

  def self.log_admin_action(club, action, details = {})
    # Find active race or create activity without race
    race = club.races.active.first

    create!(
      race: race,
      club: club,
      activity_type: action,
      message: details[:message] || "Admin #{action.humanize.downcase}",
      metadata: details
    )
  end

  private

  def broadcast_activity
    # Broadcast to admin activity feed
    broadcast_prepend_to "club_#{club.slug}_admin_activity",
                        target: "activity-feed",
                        partial: "races/activity_item",
                        locals: { activity: self }

    # Update activity counter
    broadcast_update_to "club_#{club.slug}_admin",
                       target: "activity-count",
                       html: RaceActivity.for_club(club).recent.count.to_s
  end
end
