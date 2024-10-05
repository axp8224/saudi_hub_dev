class ResourcesController < ApplicationController
  def index
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    if params[:resource_type_id].present?
      @resources = @resources.where(resource_type_id: params[:resource_type_id])
    end
  end
end