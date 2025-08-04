require "test_helper"

class RaceSettingTest < ActiveSupport::TestCase
  def setup
    @red_deer_bmx = Club.create!(name: "Red Deer BMX Association", slug: "red-deer-bmx")
    @provincial_race = @red_deer_bmx.create_race!(at_gate: 0, in_staging: 3)
  end

  test "should create valid race day settings with typical race schedule" do
    race_setting = @provincial_race.build_race_setting(
      registration_deadline: Time.parse("8:30 AM"),
      race_start_time: Time.parse("10:00 AM")
    )
    assert race_setting.valid?
  end

  test "should require race association for settings" do
    race_setting = RaceSetting.new(registration_deadline: Time.parse("9:00 AM"))
    assert_not race_setting.valid?
    assert_includes race_setting.errors[:race], "must exist"
  end

  test "should belong to organizing race" do
    race_setting = @provincial_race.create_race_setting!(
      registration_deadline: Time.parse("8:45 AM")
    )
    assert_equal @provincial_race, race_setting.race
  end

  test "notification_active? should return false when no notification message posted" do
    race_setting = @provincial_race.create_race_setting!(
      notification_message: nil,
      notification_expires_at: Time.current + 30.minutes
    )
    assert_not race_setting.notification_active?
  end

  test "notification_active? should return false when notification has no expiration time" do
    race_setting = @provincial_race.create_race_setting!(
      notification_message: "Rain delay - racing postponed 30 minutes",
      notification_expires_at: nil
    )
    assert_not race_setting.notification_active?
  end

  test "notification_active? should return false when race notification has expired" do
    race_setting = @provincial_race.create_race_setting!(
      notification_message: "Gate hold - rider equipment check",
      notification_expires_at: Time.current - 5.minutes
    )
    assert_not race_setting.notification_active?
  end

  test "notification_active? should return true for active race notifications" do
    race_setting = @provincial_race.create_race_setting!(
      notification_message: "Attention riders: Moto 25-30 report to staging area",
      notification_expires_at: Time.current + 15.minutes
    )
    assert race_setting.notification_active?
  end

  test "should allow race settings without notifications for standard race days" do
    race_setting = @provincial_race.create_race_setting!(
      registration_deadline: Time.parse("8:30 AM"),
      race_start_time: Time.parse("10:00 AM")
    )
    assert race_setting.valid?
    assert_nil race_setting.notification_message
    assert_nil race_setting.notification_expires_at
  end

  test "should handle provincial championship race settings" do
    calgary_olympics = Club.create!(name: "Calgary Olympic BMX Club")
    championship_race = calgary_olympics.create_race!(at_gate: 0, in_staging: 5)

    race_setting = championship_race.create_race_setting!(
      registration_deadline: Time.parse("7:30 AM"),
      race_start_time: Time.parse("9:00 AM"),
      notification_message: "Provincial Championship - riders meeting in 10 minutes",
      notification_expires_at: Time.current + 10.minutes
    )

    assert race_setting.valid?
    assert race_setting.notification_active?
    assert_equal championship_race, race_setting.race
  end
end
