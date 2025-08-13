require "test_helper"

class OwnershipTransferTest < ActiveSupport::TestCase
  def setup
    @club = clubs(:airdrie_bmx)
    @from_user = users(:super_admin)
    @to_email = "newowner@bmxtools.com"
  end

  test "should create valid ownership transfer" do
    transfer = OwnershipTransfer.new(
      club: @club,
      from_user: @from_user,
      to_user_email: @to_email
    )

    assert transfer.valid?
    assert transfer.save
    assert transfer.token.present?
    assert transfer.expires_at.present?
    assert transfer.pending?
  end

  test "should require valid email format" do
    transfer = OwnershipTransfer.new(
      club: @club,
      from_user: @from_user,
      to_user_email: "invalid-email"
    )

    assert_not transfer.valid?
    assert_includes transfer.errors[:to_user_email], "is invalid"
  end

  test "should not allow transfer to same user email" do
    transfer = OwnershipTransfer.new(
      club: @club,
      from_user: @from_user,
      to_user_email: @from_user.email
    )

    assert_not transfer.valid?
    assert_includes transfer.errors[:to_user_email], "cannot be the same as the current owner's email"
  end

  test "should generate unique tokens" do
    transfer1 = OwnershipTransfer.create!(
      club: @club,
      from_user: @from_user,
      to_user_email: @to_email
    )

    transfer2 = OwnershipTransfer.create!(
      club: clubs(:calgary_bmx),
      from_user: @from_user,
      to_user_email: "another@bmxtools.com"
    )

    assert_not_equal transfer1.token, transfer2.token
  end

  test "should correctly identify pending transfers" do
    transfer = ownership_transfers(:pending_transfer)
    assert transfer.pending?
    assert transfer.active?
    assert_not transfer.completed?
    assert_not transfer.cancelled?
    assert_not transfer.expired?
  end

  test "should correctly identify completed transfers" do
    transfer = ownership_transfers(:completed_transfer)
    assert_not transfer.pending?
    assert_not transfer.active?
    assert transfer.completed?
    assert_not transfer.cancelled?
  end

  test "should calculate days until expiry" do
    transfer = OwnershipTransfer.create!(
      club: @club,
      from_user: @from_user,
      to_user_email: @to_email
    )

    assert_equal 3, transfer.days_until_expiry
  end
end
