class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update]
  before_action :set_majors, only: %i[edit update]
  before_action :set_classifications, only: %i[edit update]

  def show
    @user = User.find(params[:id])
    @is_current_user = (@user.id == current_user.id)
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

    # Sorting
    if params[:sort].present?
      case params[:sort]
      when 'name_asc'
        @users = @users.order(full_name: :asc)
      when 'name_desc'
        @users = @users.order(full_name: :desc)
      when 'date_joined_asc'
        @users = @users.order(created_at: :asc)
      when 'date_joined_desc'
        @users = @users.order(created_at: :desc)
      when 'role_asc'
        @users = @users.order(role_id: :asc)
      when 'role_desc'
        @users = @users.order(role_id: :desc)
      end
    end

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
      redirect_to user_profile_path(@user)
    else
      flash.now[:alert] = t('flash.profile.update_failure')
      render :edit
    end
  end

  def remove_phone_number
    @user.update(phone_number: nil)
    flash[:success] = t('flash.profile.phone_removed')
    redirect_to edit_user_profile_path
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
    params.require(:user).permit(:full_name, :email, :avatar, :major_id, :class_year_id, :grad_year, :bio,
                                 :phone_number, :phone_public)
  end
end
