class Admin::Clubs::SettingsController < ApplicationController
  before_action :require_authentication!
  before_action :set_club
  before_action :authorize_club_access!

  def show
    @pending_transfer = @club.ownership_transfers.active.first
    @club_members = @club.users.joins(:tool_permissions)
                         .where(tool_permissions: { tool: "race_management", club: @club })
                         .includes(:tool_permissions)
  end

  def update_general
    if @club.update(club_general_params)
      redirect_to admin_club_settings_path(@club), notice: "Club settings updated successfully."
    else
      @pending_transfer = @club.ownership_transfers.active.first
      @club_members = @club.users.joins(:tool_permissions)
                           .where(tool_permissions: { tool: "race_management", club: @club })
                           .includes(:tool_permissions)
      render :show, status: :unprocessable_entity
    end
  end

  def add_member
    email = params[:email]&.strip&.downcase
    role = params[:role]

    unless %w[club_admin club_operator].include?(role)
      redirect_to admin_club_settings_path(@club), alert: "Invalid role selected."
      return
    end

    user = User.find_by(email: email)
    unless user
      redirect_to admin_club_settings_path(@club), alert: "User with email #{email} not found."
      return
    end

    # Check if user already has access to this club
    existing_permission = user.tool_permissions.find_by(tool: "race_management", club: @club)
    if existing_permission
      redirect_to admin_club_settings_path(@club), alert: "User already has access to this club."
      return
    end

    # Add permission
    user.tool_permissions.create!(
      tool: "race_management",
      role: role,
      club: @club
    )

    redirect_to admin_club_settings_path(@club), notice: "User #{email} added as #{role.humanize}."
  end

  def update_member
    user_id = params[:user_id]
    new_role = params[:role]

    unless %w[club_admin club_operator].include?(new_role)
      redirect_to admin_club_settings_path(@club), alert: "Invalid role selected."
      return
    end

    user = User.find(user_id)
    permission = user.tool_permissions.find_by(tool: "race_management", club: @club)

    unless permission
      redirect_to admin_club_settings_path(@club), alert: "User does not have access to this club."
      return
    end

    permission.update!(role: new_role)
    redirect_to admin_club_settings_path(@club), notice: "User role updated to #{new_role.humanize}."
  end

  def remove_member
    user_id = params[:user_id]
    user = User.find(user_id)

    # Don't allow removing the owner
    if @club.owned_by?(user)
      redirect_to admin_club_settings_path(@club), alert: "Cannot remove club owner. Transfer ownership first."
      return
    end

    permission = user.tool_permissions.find_by(tool: "race_management", club: @club)
    if permission
      permission.destroy!
      redirect_to admin_club_settings_path(@club), notice: "User #{user.email} removed from club."
    else
      redirect_to admin_club_settings_path(@club), alert: "User does not have access to this club."
    end
  end

  def initiate_transfer
    to_user_email = params[:to_user_email]&.strip&.downcase

    # Only owner or super admin can initiate transfers
    unless current_user.super_admin? || @club.owned_by?(current_user)
      redirect_to admin_club_settings_path(@club), alert: "Only club owners can transfer ownership."
      return
    end

    # Check if target user exists
    target_user = User.find_by(email: to_user_email)
    unless target_user
      redirect_to admin_club_settings_path(@club), alert: "User with email #{to_user_email} not found."
      return
    end

    # Cancel any existing pending transfers
    @club.ownership_transfers.active.each(&:cancel!)

    # Create new transfer
    transfer = @club.ownership_transfers.build(
      from_user: current_user,
      to_user_email: to_user_email
    )

    if transfer.save
      # TODO: Send transfer email notification
      redirect_to admin_club_settings_path(@club), notice: "Ownership transfer initiated. #{to_user_email} will receive an email to complete the transfer."
    else
      redirect_to admin_club_settings_path(@club), alert: transfer.errors.full_messages.join(", ")
    end
  end

  def cancel_transfer
    transfer = @club.ownership_transfers.active.first

    unless transfer
      redirect_to admin_club_settings_path(@club), alert: "No active transfer to cancel."
      return
    end

    # Only the initiator or super admin can cancel
    unless current_user.super_admin? || transfer.from_user == current_user
      redirect_to admin_club_settings_path(@club), alert: "You cannot cancel this transfer."
      return
    end

    if transfer.cancel!
      redirect_to admin_club_settings_path(@club), notice: "Ownership transfer cancelled."
    else
      redirect_to admin_club_settings_path(@club), alert: "Failed to cancel transfer."
    end
  end

  def soft_delete
    unless authorize_destructive_action?
      redirect_to admin_club_settings_path(@club), alert: "Not authorized to delete this club."
      return
    end

    @club.soft_delete!
    redirect_to admin_clubs_path, notice: "Club '#{@club.name}' has been deleted."
  end

  def restore
    unless current_user.super_admin?
      redirect_to admin_club_settings_path(@club), alert: "Only platform administrators can restore clubs."
      return
    end

    @club.restore!
    redirect_to admin_club_settings_path(@club), notice: "Club '#{@club.name}' has been restored."
  end

  def hard_delete
    unless current_user.super_admin?
      redirect_to admin_clubs_path, alert: "Only platform administrators can permanently delete clubs."
      return
    end

    club_name = @club.name
    @club.destroy!
    redirect_to admin_clubs_path, notice: "Club '#{club_name}' has been permanently deleted."
  end

  private

  def set_club
    @club = Club.unscoped.find_by!(slug: params[:club_id])
  end

  def authorize_club_access!
    unless current_user.super_admin? || current_user.can_manage_club?(@club)
      redirect_to admin_dashboard_path, alert: "You don't have permission to manage this club."
    end
  end

  def authorize_destructive_action?
    # Super admins can delete any club
    return true if current_user.super_admin?

    # Club owners can soft delete their own clubs
    current_user.owner_of?(@club)
  end

  def club_general_params
    params.require(:club).permit(:name, :slug, :location, :timezone, :website_url, :description, :logo)
  end
end
