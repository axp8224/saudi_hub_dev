class ResourcesController < ApplicationController
  def index
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    return unless params[:resource_type_id].present?

    @resources = @resources.where(resource_type_id: params[:resource_type_id])
  end

  def new
    @resource = Resource.new
    @resource_types = ResourceType.all
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.author = current_user

    # TODO: Once admin approval is implemented, change this to 'pending'
    # @resource.status = 'pending'
    @resource.status = 'active'

    if @resource.save
      redirect_to resources_path, notice: 'Resource was successfully created.'
    else
      @resource_types = ResourceType.all
      render :new
    end
  end

  def show
    @resource = Resource.find(params[:id])
    @resource_author = User.find(@resource.user_id) if @resource.user_id.present?
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :description, :resource_type_id, images: [])
  end

end
