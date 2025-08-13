class User < ApplicationRecord
  has_secure_password

  has_many :tool_permissions, dependent: :destroy
  has_many :owned_clubs, class_name: "Club", foreign_key: :owner_user_id, dependent: :nullify
  has_many :initiated_transfers, class_name: "OwnershipTransfer", foreign_key: :from_user_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Helper methods for permission checking
  def super_admin?
    tool_permissions.where(tool: "race_management", role: "super_admin").exists?
  end

  def admin_for?(club)
    tool_permissions.where(
      tool: "race_management",
      role: [ "club_admin", "super_admin" ],
      club: [ club, nil ]
    ).exists?
  end

  def can_manage_races?
    tool_permissions.where(tool: "race_management").exists?
  end

  # Ownership helper methods
  def owner_of?(club)
    owned_clubs.include?(club)
  end

  def owns_clubs?
    owned_clubs.any?
  end

  # Club access helper - either admin or owner
  def can_manage_club?(club)
    admin_for?(club) || owner_of?(club)
  end

  # Get clubs this user can manage
  def manageable_clubs
    if super_admin?
      Club.all
    else
      # Get clubs where user is admin or owner
      admin_club_ids = tool_permissions.where(
        tool: "race_management",
        role: "club_admin"
      ).pluck(:club_id).compact

      owned_club_ids = owned_clubs.pluck(:id)

      club_ids = (admin_club_ids + owned_club_ids).uniq
      Club.where(id: club_ids)
    end
  end
end
