module RaceTimeHelper
  def hour_options_for_select
    (6..23).map { |hour|
      time_str = hour.to_s.rjust(2, "0") + ":00"
      display = Time.parse(time_str).strftime("%l %p").strip
      [ display, hour ]
    }
  end

  def minute_options_for_select
    [
      [ ":00", 0 ],
      [ ":15", 15 ],
      [ ":30", 30 ],
      [ ":45", 45 ]
    ]
  end

  def extract_hour_from_datetime(datetime)
    return 9 if datetime.nil? # Default 9 AM
    datetime.hour
  end

  def extract_minute_from_datetime(datetime)
    return 0 if datetime.nil? # Default :00
    # Round to nearest 15-minute interval
    minutes = datetime.min
    case minutes
    when 0..7   then 0
    when 8..22  then 15
    when 23..37 then 30
    when 38..52 then 45
    else 0
    end
  end

  def build_datetime_from_parts(date, hour, minute, club)
    return nil unless date.present? && hour.present? && minute.present?

    # Parse the date and combine with time in club's timezone
    club.time_zone.parse("#{date} #{hour}:#{minute.to_s.rjust(2, '0')}")
  end

  def get_race_date(race_setting, club)
    # Use today or the existing race date if it's reasonable (not ancient)
    if race_setting.registration_deadline && race_setting.registration_deadline > 1.week.ago
      race_setting.registration_deadline.to_date
    elsif race_setting.race_start_time && race_setting.race_start_time > 1.week.ago
      race_setting.race_start_time.to_date
    else
      club.current_time.to_date
    end
  end

  def get_default_registration_time(race_setting, club)
    if race_setting.registration_deadline && race_setting.registration_deadline > 1.week.ago
      race_setting.registration_deadline
    else
      club.time_from_now(1.hour)
    end
  end

  def get_default_race_start_time(race_setting, club)
    if race_setting.race_start_time && race_setting.race_start_time > 1.week.ago
      race_setting.race_start_time
    else
      club.time_from_now(3.hours)
    end
  end
end
