class ResourceTypesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @resource_type = ResourceType.new
  end
  
  def create
    @resource_type = ResourceType.new(resource_type_params)
    if @resource_type.save
      redirect_to admin_resources_path, notice: t('admin.resource_types.created_successfully')
    else
      render :new, alert: t('admin.resource_types.creation_failed')
    end
  end
  
  private

  def resource_type_params
    params.require(:resource_type).permit(:title)
  end
end