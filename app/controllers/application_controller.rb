class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Security headers
  before_action :set_security_headers

  # CSRF protection is enabled by default in Rails
  protect_from_forgery with: :exception

  private

  def set_security_headers
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
  end

  # Authentication helpers
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def require_authentication!
    unless signed_in?
      redirect_to login_path, alert: "Please sign in to continue"
    end
  end

  def require_super_admin!
    require_authentication!
    unless current_user&.super_admin?
      redirect_to root_path, alert: "Access denied"
    end
  end

  def require_club_admin!(club)
    require_authentication!
    unless current_user&.admin_for?(club)
      redirect_to root_path, alert: "Access denied"
    end
  end

  # Make current_user available in views
  helper_method :current_user, :signed_in?
end
