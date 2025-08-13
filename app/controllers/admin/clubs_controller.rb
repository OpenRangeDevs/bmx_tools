class Admin::ClubsController < Admin::BaseController
  before_action :set_club, only: [ :show, :edit, :update, :destroy ]

  def index
    @clubs = Club.includes(:race)

    # Search functionality
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @clubs = @clubs.where("name LIKE ? OR location LIKE ? OR slug LIKE ?",
                           search_term, search_term, search_term)
    end

    # Filter by status
    case params[:status]
    when "active"
      @clubs = @clubs.where(deleted_at: nil)
    when "deleted"
      @clubs = @clubs.where.not(deleted_at: nil)
    else
      # Show all by default (including soft deleted)
      @clubs = @clubs.unscoped
    end

    # Sort functionality
    sort_column = params[:sort] || "name"
    sort_direction = params[:direction] || "asc"
    @clubs = @clubs.order("#{sort_column} #{sort_direction}")

    # Pagination would go here if needed
    @clubs = @clubs.limit(50)
  end

  def show
    @race_stats = {
      total_races: @club.race ? 1 : 0,
      last_activity: @club.race&.updated_at,
      current_at_gate: @club.race&.at_gate || 0,
      current_in_staging: @club.race&.in_staging || 0
    }
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(club_params)

    if @club.save
      # Create club admin user if email provided
      if params[:admin_email].present?
        create_club_admin
      end

      # Create initial race for the club
      Race.create!(club: @club, at_gate: 0, in_staging: 0)

      redirect_to admin_club_path(@club), notice: "Club was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @club.update(club_params)
      redirect_to admin_club_path(@club), notice: "Club was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Soft delete
    @club.update(deleted_at: Time.current)
    redirect_to admin_clubs_path, notice: "Club was successfully deleted."
  end

  private

  def set_club
    @club = Club.unscoped.find_by!(slug: params[:id])
  end

  def club_params
    params.require(:club).permit(:name, :slug, :location, :contact_email, :timezone)
  end

  def create_club_admin
    password = params[:admin_password].presence || SecureRandom.hex(8)

    user = User.create!(
      email: params[:admin_email],
      password: password,
      password_confirmation: password
    )

    ToolPermission.create!(
      user: user,
      tool: "race_management",
      role: "club_admin",
      club: @club
    )

    flash[:admin_credentials] = {
      email: params[:admin_email],
      password: password
    }
  end
end
