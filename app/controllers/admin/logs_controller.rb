module Admin
  class LogsController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      @logs = Log.order(created_at: :desc).all
    end

    private
    def admin_only
      return if current_user.role.name == 'admin'
      redirect_to root_path, alert: t('flash.admin.access_denied')
    end
  end
end
