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

        Log.create(
          user_email: current_user.email,
          action: "Created Resource Type",
          description: "Created new resource type named '#{@resource_type.title}'",
          action_timestamp: Time.current
        )

      else
        render :new
        Log.create(
          user_email: current_user.email,
          action: "Failed to Create Resource Type",
          description: "Attempt to create new resource type failed",
          action_timestamp: Time.current
        )
      end
    end

    def edit
      @resource_type = ResourceType.find(params[:id])
    end
  
    def update
      @resource_type = ResourceType.find(params[:id])
      if @resource_type.update(resource_type_params)
        redirect_to admin_resources_path, notice: 'Resource type was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @resource_type = ResourceType.find(params[:id])

      @resource_type.resources.update_all(resource_type_id: nil, status: 'archived')
      
      if @resource_type.destroy
        redirect_to admin_resources_path, notice: 'Resource type was successfully deleted and related resources archived.'
      else
        redirect_to admin_resources_path, alert: 'Failed to delete the resource type.'
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
  