class ResourcesController < ApplicationController
  def index
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    return unless params[:resource_type_id].present?

    @resources = @resources.where(resource_type_id: params[:resource_type_id])
  end

  def show
    @resource = Resource.find(params[:id])
    @resource_author = User.find(@resource.user_id) if @resource.user_id.present?
  end
end
