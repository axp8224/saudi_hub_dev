module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
      @roles = Role.all
    end

    def update
      @user = User.find(params[:id])
      if @user.update(role_id: params[:user][:role_id])
        redirect_to admin_users_path, notice: "#{@user.full_name}'s role was updated successfully."
      else
        flash.now[:alert] = "Unable to update role."
        render :edit
      end
    end

    private

    def admin_only
      unless current_user.role.name == 'admin'
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
end
