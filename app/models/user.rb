class User < ApplicationRecord
  has_secure_password
  
  has_many :tool_permissions, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Helper methods for permission checking
  def super_admin?
    tool_permissions.where(tool: 'race_management', role: 'super_admin').exists?
  end
  
  def admin_for?(club)
    tool_permissions.where(
      tool: 'race_management',
      role: ['club_admin', 'super_admin'],
      club: [club, nil]
    ).exists?
  end
  
  def can_manage_races?
    tool_permissions.where(tool: 'race_management').exists?
  end
end
