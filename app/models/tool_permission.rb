class ToolPermission < ApplicationRecord
  belongs_to :user
  belongs_to :club, optional: true  # null for super_admin
  
  enum :tool, { race_management: 0 }
  enum :role, { super_admin: 0, club_admin: 1, club_operator: 2 }
  
  validates :user, presence: true
  validates :tool, presence: true
  validates :role, presence: true
  validates :user_id, uniqueness: { scope: [:tool, :club_id] }
  
  # Custom validation: super_admin must have club_id = nil
  validate :super_admin_has_no_club
  
  private
  
  def super_admin_has_no_club
    if super_admin? && club_id.present?
      errors.add(:club, "must be blank for super_admin role")
    elsif !super_admin? && club_id.blank?
      errors.add(:club, "must be present for non-super_admin roles")
    end
  end
end
