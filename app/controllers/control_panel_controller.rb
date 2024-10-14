class ControlPanelController < ApplicationController
  before_action :check_panel_enabled

  def home
    @users = User.all
  end

  def promote
    @user = User.find(params[:id])
    admin_role = Role.find_by(name: 'admin')

    if @user.update(role: admin_role)
      flash[:success] = "User #{@user.full_name} has been successfully promoted to admin."
    else
      flash[:alert] = "Failed to promote the user to admin."
    end

    redirect_to control_panel_home_path
  end

  def demote
    @user = User.find(params[:id])
    user_role = Role.find_by(name: 'user')

    if @user.update(role: user_role)
      flash[:success] = "User #{@user.full_name} has been successfully demoted to user."
    else
      flash[:alert] = "Failed to demote the user to user."
    end

    redirect_to control_panel_home_path
  end

  private

  def check_panel_enabled
    unless ENV['ENABLE_PANEL'] == 'true'
      flash[:alert] = "Access denied. The control panel is not enabled."
      redirect_to root_path
    end
  end
end
