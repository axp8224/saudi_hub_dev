module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      per_page = params[:per_page] || 10 # Default to 10 if not set
      if params[:search].present?
        search_query = "%#{params[:search]}%"
        @users = User.where('full_name ILIKE :search OR email ILIKE :search',
                            search: search_query).page(params[:page]).per(per_page)
      else
        @users = User.page(params[:page]).per(per_page)
      end
    end

    def edit
      @user = User.find(params[:id])
      @roles = Role.all
    end

    def update
      @user = User.find(params[:id])
      original_role_name = @user.role.name

      if @user.update(role_id: params[:user][:role_id])
        new_role_name = @user.role.reload.name
        change_description = "Role changed from '#{original_role_name}' to '#{new_role_name}'"

        flash[:success] = t('flash.admin.role_update_success', name: @user.full_name)

        Log.create(
          user_email: current_user.email,
          action: "Updated User",
          description: "Updated user [#{@user.full_name}] -> #{change_description}",
          action_timestamp: Time.current
        )
        redirect_to admin_users_path
      else
        flash.now[:alert] = t('flash.admin.role_update_failure')

        Log.create(
          user_email: current_user.email,
          action: "Failed to Update User",
          description: "Attempted update on user [#{@user.full_name}] failed to apply",
          action_timestamp: Time.current
        )
        
        render :edit
      end
    end

    private

    def admin_only
      return if current_user.role.name == 'admin'

      flash[:alert] = t('flash.admin.access_denied')
      redirect_to root_path
    end
  end
end
