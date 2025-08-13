class Admin::DashboardController < Admin::BaseController
  def index
    @total_clubs = Club.count
    @active_clubs = Club.joins(:race).distinct.count
    @total_races = Race.count
    @active_races = Race.where("updated_at > ?", 1.hour.ago).count
    @recent_activity = build_recent_activity
  end

  private

  def build_recent_activity
    # Simplified activity tracking for Phase 6.2
    # Will be enhanced in future phases
    activities = []

    # Recent club creations
    Club.where("created_at > ?", 24.hours.ago)
        .order(created_at: :desc)
        .limit(3)
        .each do |club|
      activities << {
        timestamp: club.created_at,
        message: "New club created: #{club.name}",
        type: "club_creation"
      }
    end

    # Recent race activity (based on updates)
    Race.joins(:club)
        .where("races.updated_at > ?", 4.hours.ago)
        .order(updated_at: :desc)
        .limit(5)
        .each do |race|
      activities << {
        timestamp: race.updated_at,
        message: "#{race.club.name} race updated (At Gate: #{race.at_gate}, In Staging: #{race.in_staging})",
        type: "race_update"
      }
    end

    # Sort by timestamp and return most recent 10
    activities.sort_by { |activity| activity[:timestamp] }
             .reverse
             .first(10)
  end
end
