require "test_helper"

class ClubTest < ActiveSupport::TestCase
  test "should create valid club with name and auto-generated slug" do
    club = Club.new(name: "Calgary Olympic BMX Club", location: "Calgary, AB", timezone: "Mountain Time (US & Canada)")
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
    Club.create!(name: "Camrose BMX Track", slug: "camrose-bmx", location: "Camrose, AB", timezone: "Mountain Time (US & Canada)")
    club = Club.new(name: "Camrose Racing Club", slug: "camrose-bmx", location: "Camrose, AB", timezone: "Mountain Time (US & Canada)")
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
    valid_slugs = [ "spruce-grove-2024", "sherwood-park-bmx-association", "okotoks-racing", "canmore-bmx", "brooks-unique-bmx" ]
    valid_slugs.each do |slug|
      club = Club.new(name: "Brooks BMX Club", slug: slug, location: "Brooks, AB", timezone: "Mountain Time (US & Canada)")
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

  # Phase 6.5 - Club Settings Tests
  test "should accept valid website URL" do
    club = Club.new(
      name: "Red Deer BMX Club",
      location: "Red Deer, AB",
      timezone: "Mountain Time (US & Canada)",
      website_url: "https://reddeer.bmxtools.com"
    )
    assert club.valid?
  end

  test "should validate website URL format" do
    club = Club.new(
      name: "Medicine Hat BMX Track",
      location: "Medicine Hat, AB",
      timezone: "Mountain Time (US & Canada)",
      website_url: "not-a-valid-url"
    )
    assert_not club.valid?
    assert_includes club.errors[:website_url], "must be a valid URL"
  end

  test "should accept blank website URL" do
    club = Club.new(
      name: "Grande Prairie BMX",
      location: "Grande Prairie, AB",
      timezone: "Mountain Time (US & Canada)",
      website_url: ""
    )
    assert club.valid?
  end

  test "should have owner relationship" do
    club = clubs(:airdrie_bmx)
    owner = users(:club_admin)
    club.update!(owner_user: owner)

    assert_equal owner, club.owner_user
    assert_equal owner.id, club.owner_user_id
  end

  test "owned_by? should return true for owner" do
    club = clubs(:airdrie_bmx)
    owner = users(:club_admin)
    non_owner = users(:club_operator)
    club.update!(owner_user: owner)

    assert club.owned_by?(owner)
    assert_not club.owned_by?(non_owner)
    assert_not club.owned_by?(nil)
  end

  test "should have many ownership transfers" do
    club = clubs(:airdrie_bmx)
    transfer = club.ownership_transfers.build(
      from_user: users(:club_admin),
      to_user_email: "newowner@example.com"
    )

    assert transfer.valid?
    assert_includes club.ownership_transfers, transfer
  end

  test "should have logo attachment" do
    club = clubs(:airdrie_bmx)
    assert_respond_to club, :logo
    assert club.logo.respond_to?(:attached?)
  end

  test "should soft delete club and set deleted_at timestamp" do
    club = clubs(:airdrie_bmx)
    assert_nil club.deleted_at
    assert_not club.deleted?

    club.soft_delete!

    assert_not_nil club.deleted_at
    assert club.deleted?
  end

  test "should restore soft deleted club" do
    club = clubs(:airdrie_bmx)
    club.soft_delete!
    assert club.deleted?

    club.restore!

    assert_nil club.deleted_at
    assert_not club.deleted?
  end

  test "should exclude soft deleted clubs from default scope" do
    original_count = Club.count
    club = clubs(:airdrie_bmx)

    club.soft_delete!

    assert_equal original_count - 1, Club.count
    assert_not_includes Club.all, club
  end

  test "should include soft deleted clubs in unscoped queries" do
    club = clubs(:airdrie_bmx)
    club.soft_delete!

    assert_includes Club.unscoped, club
  end

  test "should have deleted scope for soft deleted clubs" do
    active_club = clubs(:airdrie_bmx)
    deleted_club = clubs(:calgary_bmx)
    deleted_club.soft_delete!

    assert_includes Club.unscoped.deleted, deleted_club
    assert_not_includes Club.unscoped.deleted, active_club
  end
end
