class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  private

  def require_admin!
    unless current_user.admin? || current_user.super_admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
