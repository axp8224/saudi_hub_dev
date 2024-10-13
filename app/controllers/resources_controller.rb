class ResourcesController < ApplicationController
  def index
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    # Filter resources by type if specified
    @resources = @resources.where(resource_type_id: params[:resource_type_id]) if params[:resource_type_id].present?

    # Filter by search query if present
    if params[:search].present?
      @resources = @resources.where('title ILIKE :search OR description ILIKE :search', search: "%#{params[:search]}%")
    end

    if @resources.empty?
      flash.now[:notice] = t('search.no_results')
    end

    # Paginate the resources
    per_page = params[:per_page] || 10 # Set a default per page value
    @resources = @resources.page(params[:page]).per(per_page)
  end

  def show
    @resource = Resource.find(params[:id])
    @resource_author = User.find(@resource.user_id) if @resource.user_id.present?
  end
end
