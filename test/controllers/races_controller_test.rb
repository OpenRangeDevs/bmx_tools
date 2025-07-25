require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @club = Club.create!(
      name: "Calgary BMX Association", 
      slug: "calgary-bmx"
    )
  end

  test "should get show" do
    get club_race_url(@club.slug)
    assert_response :success
  end

  test "should get admin" do
    get club_admin_url(@club.slug)
    assert_response :success
  end

  test "should update race via turbo stream" do
    race = @club.races.create!(at_gate: 5, in_staging: 8)
    
    patch club_race_update_url(@club.slug), 
          params: { race: { at_gate: 6, in_staging: 8 } },
          headers: { "Accept": "text/vnd.turbo-stream.html" }
    
    assert_response :success
    assert_match "turbo-stream", response.content_type
    race.reload
    assert_equal 6, race.at_gate
    assert_equal 8, race.in_staging
  end

  test "race model has broadcast callback" do
    race = @club.races.create!(at_gate: 3, in_staging: 5)
    
    # Test that the broadcast_race_update method exists and works
    assert_respond_to race, :send
    assert_nothing_raised do
      race.send(:broadcast_race_update)
    end
  end
end
