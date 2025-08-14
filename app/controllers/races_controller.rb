class RacesController < ApplicationController
  include RaceTimeHelper

  before_action :find_club_by_slug
  before_action :find_or_create_race
  before_action :require_club_admin!, only: [ :admin, :update, :update_settings, :create_new_race ]

  def show
    # Public race tracking display for spectators and riders
  end

  def admin
    # Admin interface for race officials
    # Ensure we have fresh data from database
    @race.reload
    @race_setting.reload if @race_setting
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
            turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: { notice: "Race times updated successfully" } }),
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

  def create_new_race
    # Reset existing race with fresh defaults
    @race.update!(
      at_gate: 0,
      in_staging: 0
    )

    # Update race settings with proper defaults (force new times)
    @race_setting.update!(
      registration_deadline: @club.time_from_now(1.hour),
      race_start_time: @club.time_from_now(3.hours)
    )

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: { notice: "Race reset successfully with updated times!" } }),
          turbo_stream.replace("race-time-settings", partial: "race_time_settings", locals: { race_setting: @race_setting, club: @club }),
          turbo_stream.replace("admin-counters", partial: "admin_counters", locals: { race: @race, club: @club })
        ]
      }
      format.html { redirect_to club_admin_path(@club), notice: "Race reset successfully!" }
    end
  end

  private

  def find_club_by_slug
    @club = Club.find_by(slug: params[:club_slug])

    if @club.nil?
      render plain: "BMX club '#{params[:club_slug]}' not found. Available clubs: #{Club.pluck(:slug).join(', ')}", status: :not_found
    end
  end

  def find_or_create_race
    existing_race = @club.race

    if existing_race
      @race = existing_race
    else
      @race = @club.create_race!(at_gate: 0, in_staging: 0)
    end

    @race_setting = @race.race_setting || @race.create_race_setting!
  end

  def race_params
    params.require(:race).permit(:at_gate, :in_staging)
  end

  def race_setting_params
    permitted_params = params.require(:race_setting).permit(
      :registration_deadline, :race_start_time,
      :race_date, :registration_hour, :registration_minute,
      :race_start_hour, :race_start_minute
    )

    # If we have separate date/time components, build the datetime values
    if permitted_params[:race_date].present?
      if permitted_params[:registration_hour].present? && permitted_params[:registration_minute].present?
        permitted_params[:registration_deadline] = build_datetime_from_parts(
          permitted_params[:race_date],
          permitted_params[:registration_hour],
          permitted_params[:registration_minute],
          @club
        )
      end

      if permitted_params[:race_start_hour].present? && permitted_params[:race_start_minute].present?
        permitted_params[:race_start_time] = build_datetime_from_parts(
          permitted_params[:race_date],
          permitted_params[:race_start_hour],
          permitted_params[:race_start_minute],
          @club
        )
      end
    end

    # Only return the datetime fields that the model expects
    permitted_params.slice(:registration_deadline, :race_start_time)
  end


  def require_club_admin!
    unless signed_in?
      redirect_to login_path, alert: "Please sign in to continue"
      return
    end

    unless current_user&.admin_for?(@club)
      redirect_to login_path, alert: "Access denied"
      nil
    end
  end
end
