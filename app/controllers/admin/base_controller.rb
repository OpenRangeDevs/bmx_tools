class Admin::BaseController < ApplicationController
  before_action :require_super_admin!

  private

  def require_super_admin!
    unless signed_in?
      redirect_to login_path, alert: "Please sign in to continue"
      return
    end

    unless current_user&.super_admin?
      redirect_to root_path, alert: "Access denied"
      nil
    end
  end
end
