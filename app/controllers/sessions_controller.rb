class SessionsController < ApplicationController
  def new
    # Login form
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      session[:login_time] = Time.current.to_s
      
      # Role-based redirect
      if user.super_admin?
        redirect_to admin_dashboard_path, notice: "Successfully logged in as Super Admin"
      elsif user.can_manage_races?
        # Find the user's club for redirect
        club_permission = user.tool_permissions.where(tool: 'race_management').joins(:club).first
        if club_permission&.club
          redirect_to club_admin_path(club_permission.club), notice: "Successfully logged in"
        else
          redirect_to root_path, notice: "Successfully logged in"
        end
      else
        redirect_to root_path, notice: "Successfully logged in"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Successfully logged out"
  end
end
