class HomeController < ApplicationController
  def index
    @active_clubs = Club.joins(:race)
                       .includes(:race, race: :race_setting)
                       .where.not(races: { id: nil })
                       .order(:name)
    
    @inactive_clubs = Club.left_joins(:race)
                         .where(races: { id: nil })
                         .order(:name)
    
    @all_clubs = @active_clubs + @inactive_clubs
  end

  private

  def race_status(club)
    return "No Race Scheduled" unless club.race

    race_setting = club.race.race_setting
    return "Racing Active" unless race_setting

    now = Time.current
    
    if race_setting.race_start_time && now >= race_setting.race_start_time
      "Racing in Progress"
    elsif race_setting.registration_deadline && now <= race_setting.registration_deadline
      "Registration Open"
    elsif race_setting.race_start_time && now < race_setting.race_start_time
      "Registration Closed - Race Scheduled"
    else
      "Race Scheduled"
    end
  end

  def status_badge_classes(status)
    case status
    when "Racing in Progress", "Racing Active"
      "bg-green-100 text-green-800"
    when "Registration Open"
      "bg-blue-100 text-blue-800"
    when "Registration Closed - Race Scheduled", "Race Scheduled"
      "bg-yellow-100 text-yellow-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  helper_method :race_status, :status_badge_classes
end