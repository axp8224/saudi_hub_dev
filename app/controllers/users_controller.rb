class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update]
  before_action :set_majors, only: %i[edit update]
  before_action :set_classifications, only: %i[edit update]

  def show
    @user = current_user
  end

  def index
    per_page = params[:per_page] || 10

    # Base query
    @users = User.includes(:role, :major, :class_year)

    # Search filter
    if params[:search].present?
      search_query = "%#{params[:search]}%"
      @users = @users.where('full_name ILIKE :search OR email ILIKE :search', search: search_query)
    end

    # Filter by major
    @users = @users.where(major_id: params[:major]) if params[:major].present?

    # Filter by class_year
    @users = @users.where(class_year_id: params[:class_year]) if params[:class_year].present?

    # Pagination
    @users = @users.page(params[:page]).per(per_page)

    # For the form dropdowns
    @majors = Major.all
    @class_years = ClassYear.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('flash.profile.update_success')
      redirect_to root_path
    else
      flash.now[:alert] = t('flash.profile.update_failure')
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_majors
    @majors = Major.all
  end

  def set_classifications
    @class_years = ClassYear.all
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :avatar, :major_id, :class_year_id, :grad_year, :bio)
  end
end
