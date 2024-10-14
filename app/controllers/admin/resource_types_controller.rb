module Admin
  class ResourceTypesController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def new
      @resource_type = ResourceType.new
    end
  
    def create
      @resource_type = ResourceType.new(resource_type_params)
      if @resource_type.save
        redirect_to admin_resources_path, notice: 'Resource type was successfully created.'
      else
        render :new
      end
    end
  
    private

    def resource_type_params
      params.require(:resource_type).permit(:title)
    end

    def admin_only
      return if current_user.role.name == 'admin'
  
      flash[:alert] = t('flash.admin.access_denied')
      redirect_to root_path
    end
  end
end
  