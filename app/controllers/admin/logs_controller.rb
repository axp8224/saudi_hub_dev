module Admin
  class LogsController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index

      # filter implementation
      if params[:log_action].present?
        @logs = Log.where("action ILIKE ?", "%#{params[:log_action]}%")
      else
        @logs = Log.order(action_timestamp: :desc).all
      end
      
      # search functionality implementation
      if params[:search].present?
        @logs = @logs.where("user_email ILIKE :search OR action ILIKE :search OR description ILIKE :search", search: "%#{params[:search]}%")
      end

      if @logs.empty?
        flash.now[:notice] = t('search.no_results')
      end

      per_page = params[:per_page] || 10 # Set a default per page value
      @logs = @logs.page(params[:page]).per(per_page)

    end

    private
    def admin_only
      return if current_user.role.name == 'admin'
      redirect_to root_path, alert: t('flash.admin.access_denied')
    end
  end
end
