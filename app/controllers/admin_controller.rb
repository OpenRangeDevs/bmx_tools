class AdminController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_session_timeout!
  layout 'admin'

  # Session timeout: 4 hours
  SESSION_TIMEOUT = 4.hours

  private

  def authenticate_admin!
    unless admin_authenticated?
      redirect_to admin_login_path, alert: 'Please log in to access admin features'
    end
  end

  def admin_authenticated?
    session[:admin_authenticated] == true && session[:admin_login_time].present?
  end

  def check_session_timeout!
    if session[:admin_login_time].present?
      last_activity = Time.zone.parse(session[:admin_login_time])
      if Time.current - last_activity > SESSION_TIMEOUT
        reset_session
        redirect_to admin_login_path, alert: 'Your session has expired. Please log in again.'
        return false
      else
        # Update last activity time
        session[:admin_login_time] = Time.current.to_s
      end
    end
  end

  def admin_login_path
    club_admin_login_path(@club)
  end

  def reset_admin_session!
    session.delete(:admin_authenticated)
    session.delete(:admin_login_time)
    session.delete(:admin_club_slug)
  end
end