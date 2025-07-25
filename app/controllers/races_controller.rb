class RacesController < ApplicationController
  before_action :find_club_by_slug
  before_action :find_or_create_active_race
  before_action :authenticate_admin!, only: [:admin, :update, :update_settings]

  def show
    # Public race tracking display for spectators and riders
  end

  def admin
    # Admin interface for race officials
  end

  def update
    if @race.update(race_params)
      respond_to do |format|
        format.turbo_stream
        format.json { render json: { success: true, race: @race } }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: { error: @race.errors.full_messages.first } }) }
        format.json { render json: { success: false, errors: @race.errors.full_messages } }
      end
    end
  end

  def update_settings
    if @race_setting.update(race_setting_params)
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: { notice: 'Race times updated successfully' } }),
            turbo_stream.replace("race-time-settings", partial: "race_time_settings", locals: { race_setting: @race_setting, club: @club })
          ]
        }
        format.json { render json: { success: true, race_setting: @race_setting } }
      end
    else
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: { alert: @race_setting.errors.full_messages.first } })
        }
        format.json { render json: { success: false, errors: @race_setting.errors.full_messages } }
      end
    end
  end

  private

  def find_club_by_slug
    @club = Club.find_by(slug: params[:club_slug])
    if @club.nil?
      render plain: "BMX club '#{params[:club_slug]}' not found. Available clubs: #{Club.pluck(:slug).join(', ')}", status: :not_found
    end
  end

  def find_or_create_active_race
    @race = @club.races.active.first || @club.races.create!(at_gate: 0, in_staging: 0)
    @race_setting = @race.race_setting || @race.create_race_setting!
  end

  def race_params
    params.require(:race).permit(:at_gate, :in_staging)
  end

  def race_setting_params
    params.require(:race_setting).permit(:registration_deadline, :race_start_time)
  end

  def authenticate_admin!
    unless admin_authenticated?
      redirect_to club_admin_login_path(@club), alert: 'Please log in to access admin features'
      return
    end
    check_session_timeout!
  end

  def admin_authenticated?
    session[:admin_authenticated] == true && session[:admin_login_time].present?
  end

  def check_session_timeout!
    return unless session[:admin_login_time].present?
    
    last_activity = Time.zone.parse(session[:admin_login_time])
    if Time.current - last_activity > 4.hours
      reset_session
      redirect_to club_admin_login_path(@club), alert: 'Your session has expired. Please log in again.'
    else
      # Update last activity time
      session[:admin_login_time] = Time.current.to_s
    end
  end
end
