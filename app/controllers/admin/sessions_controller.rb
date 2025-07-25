class Admin::SessionsController < ApplicationController
  before_action :set_club
  before_action :redirect_if_authenticated, only: [:new, :create]

  def new
    # Login form
  end

  def create
    if valid_admin_password?
      session[:admin_authenticated] = true
      session[:admin_login_time] = Time.current.to_s
      session[:admin_club_slug] = @club.slug
      redirect_to club_admin_path(@club), notice: 'Successfully logged in'
    else
      flash.now[:alert] = 'Invalid password'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to club_path(@club), notice: 'Successfully logged out'
  end

  private

  def valid_admin_password?
    return false if params[:password].blank?
    
    # Simple password check - in production this would use environment variable
    # For development, use a simple password
    admin_password = Rails.env.production? ? 
      Rails.application.credentials.admin_password : 
      'admin123'
    
    params[:password] == admin_password
  end

  def redirect_if_authenticated
    if session[:admin_authenticated] && session[:admin_login_time].present?
      redirect_to club_admin_path(@club)
    end
  end

  def set_club
    @club = Club.find_by!(slug: params[:club_slug])
  end
end