require "test_helper"

class ClubTest < ActiveSupport::TestCase
  test "should create valid club with name and auto-generated slug" do
    club = Club.new(name: "Calgary Olympic BMX Club")
    assert club.valid?
    assert_equal "calgary-olympic-bmx-club", club.slug
  end

  test "should require name" do
    club = Club.new(slug: "edmonton-bmx")
    assert_not club.valid?
    assert_includes club.errors[:name], "can't be blank"
  end

  test "should require slug when name is empty" do
    club = Club.new(name: "", slug: "")
    assert_not club.valid?
    assert_includes club.errors[:slug], "can't be blank"
  end

  test "should enforce unique slug" do
    Club.create!(name: "Red Deer BMX Association", slug: "red-deer-bmx")
    club = Club.new(name: "Red Deer Racing Club", slug: "red-deer-bmx")
    assert_not club.valid?
    assert_includes club.errors[:slug], "has already been taken"
  end

  test "should validate slug format" do
    invalid_slugs = [ "Calgary BMX", "fort_saskatchewan", "lethbridge@bmx", "medicine.hat", "GRANDE-PRAIRIE" ]
    invalid_slugs.each do |slug|
      club = Club.new(name: "Camrose BMX Track", slug: slug)
      assert_not club.valid?, "#{slug} should be invalid"
      assert_includes club.errors[:slug], "must be URL-friendly (lowercase letters, numbers, and hyphens only)"
    end
  end

  test "should accept valid slug formats" do
    valid_slugs = [ "airdrie-bmx", "spruce-grove-2024", "sherwood-park-bmx-association", "okotoks-racing", "canmore-bmx" ]
    valid_slugs.each do |slug|
      club = Club.new(name: "Brooks BMX Club", slug: slug)
      assert club.valid?, "#{slug} should be valid"
    end
  end

  test "should use slug for to_param" do
    club = Club.create!(name: "Cochrane BMX Track", slug: "cochrane-bmx")
    assert_equal "cochrane-bmx", club.to_param
  end

  test "should have one race with dependent destroy" do
    club = Club.create!(name: "Strathmore BMX Racing")
    race = club.create_race!(at_gate: 0, in_staging: 1)

    assert_not_nil club.race
    club.destroy
    assert_equal 0, Race.count
  end

  test "should auto-generate slug from name" do
    club = Club.create!(name: "Peace River BMX Track & Racing Association")
    assert_equal "peace-river-bmx-track-racing-association", club.slug
  end
end
