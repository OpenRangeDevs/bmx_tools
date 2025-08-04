require "test_helper"

class RaceTest < ActiveSupport::TestCase
  def setup
    @edmonton_bmx = Club.create!(name: "Edmonton BMX Association", slug: "edmonton-bmx")
  end

  test "should create valid race with default values for pre-race setup" do
    race = @edmonton_bmx.build_race
    assert race.valid?
    assert_equal 0, race.at_gate
    assert_equal 0, race.in_staging
  end

  test "should require club association for race day tracking" do
    race = Race.new(at_gate: 0, in_staging: 1)
    assert_not race.valid?
    assert_includes race.errors[:club], "must exist"
  end

  test "should validate at_gate moto number is non-negative" do
    race = @edmonton_bmx.build_race(at_gate: -1, in_staging: 0)
    assert_not race.valid?
    assert_includes race.errors[:at_gate], "must be greater than or equal to 0"
  end

  test "should validate in_staging moto number is non-negative" do
    race = @edmonton_bmx.build_race(at_gate: 0, in_staging: -1)
    assert_not race.valid?
    assert_includes race.errors[:in_staging], "must be greater than or equal to 0"
  end

  test "should validate moto at gate is less than moto in staging during active racing" do
    race = @edmonton_bmx.build_race(at_gate: 15, in_staging: 12)
    assert_not race.valid?
    assert_includes race.errors[:at_gate], "must be less than staging counter"
  end

  test "should allow both counters at zero before racing begins" do
    race = @edmonton_bmx.build_race(at_gate: 0, in_staging: 0)
    assert race.valid?
  end

  test "should allow valid moto progression scenarios" do
    valid_moto_combinations = [
      [ 0, 0 ],   # Pre-race: no motos yet
      [ 0, 1 ],   # First moto staging, none at gate
      [ 0, 3 ],   # Multiple motos staging before racing starts
      [ 5, 8 ],   # Mid-race: moto 5 racing, moto 8 staging
      [ 12, 15 ], # Later in race day
      [ 45, 50 ]  # Large race with many motos
    ]

    valid_moto_combinations.each do |at_gate, in_staging|
      race = @edmonton_bmx.build_race(at_gate: at_gate, in_staging: in_staging)
      assert race.valid?, "Moto #{at_gate} at gate, Moto #{in_staging} staging should be valid"
    end
  end

  test "should reject invalid moto progression scenarios" do
    invalid_moto_combinations = [
      [ 1, 1 ],   # Same moto cannot be at gate and staging
      [ 8, 8 ],   # Same moto cannot be at gate and staging
      [ 15, 12 ], # Moto 15 cannot race before moto 12 stages
      [ 25, 20 ]  # Moto 25 cannot race before moto 20 stages
    ]

    invalid_moto_combinations.each do |at_gate, in_staging|
      race = @edmonton_bmx.build_race(at_gate: at_gate, in_staging: in_staging)
      assert_not race.valid?, "Moto #{at_gate} at gate, Moto #{in_staging} staging should be invalid"
      assert_includes race.errors[:at_gate], "must be less than staging counter"
    end
  end


  test "should have one race_setting with dependent destroy for race day configuration" do
    calgary_olympic = Club.create!(name: "Calgary Olympic BMX Club")
    race = calgary_olympic.create_race!(at_gate: 0, in_staging: 1)
    race_setting = race.create_race_setting!(
      registration_deadline: Time.parse("9:00 AM"),
      race_start_time: Time.parse("10:00 AM")
    )

    assert_equal race_setting, race.race_setting
    race.destroy
    assert_equal 0, RaceSetting.count
  end

  test "should belong to organizing club" do
    race = @edmonton_bmx.create_race!(at_gate: 0, in_staging: 1)
    assert_equal @edmonton_bmx, race.club
  end
end
