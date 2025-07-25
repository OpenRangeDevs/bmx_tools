class RacesController < ApplicationController
  before_action :find_club_by_slug
  before_action :find_or_create_active_race

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
end
