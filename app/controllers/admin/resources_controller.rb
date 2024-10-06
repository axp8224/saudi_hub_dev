module Admin
  class ResourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      
      @resource_types = ResourceType.all

      @resources = Resource.all

      if params[:resource_type_id].present? 
        @resources = @resources.where(resource_type_id: params[:resource_type_id])
      end

      if params[:status].present?
        @resources = @resources.where(status: params[:status])
      end

      if params[:search].present?
        search_query = "%#{params[:search]}%"
        @resources = @resources.where("title ILIKE :search OR description ILIKE :search", search: search_query)
      end

    end

    def edit 
      @resource = Resource.find(params[:id])
      @resource_types = ResourceType.all
    end

    def update
      @resource = Resource.find(params[:id])
      if @resource.update(
        status: params[:resource][:status], 
        title: params[:resource][:title], 
        description: params[:resource][:description], 
        resource_type_id: params[:resource][:resource_type_id])

        redirect_to admin_resources_path, notice: "Resource #{@resource.title} was updated successfully."
      else
        flash.now[:alert] = "Unable to update resource."
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