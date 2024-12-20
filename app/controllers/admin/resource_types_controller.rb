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
      original_name = @resource_type.title

      if @resource_type.update(resource_type_params)
        redirect_to admin_resources_path, notice: 'Resource type was successfully updated.'

        changes = []
        changes << "name from '#{original_name}' to '#{@resource_type.title}'" if @resource_type.title != original_name
        change_description = changes.join(", ")

        Log.create(
          user_email: current_user.email,
          action: "Updated Resource Type",
          description: "Updated resource type [#{original_name}] -> #{change_description}",
          action_timestamp: Time.current
        )

      else
        render :edit

        Log.create(
          user_email: current_user.email,
          action: "Failed to Update ResourceType",
          description: "Failed to update resource type: '#{original_name}'",
          action_timestamp: Time.current
        )
      end
    end
  
    def destroy
      @resource_type = ResourceType.find(params[:id])
      resource_type_name = @resource_type.title

      @resource_type.resources.update_all(resource_type_id: nil, status: 'archived')
      
      if @resource_type.destroy
        redirect_to admin_resources_path, notice: 'Resource type was successfully deleted and related resources archived.'

        Log.create(
          user_email: current_user.email,
          action: "Deleted Resource Type",
          description: "Deleted resource type '#{resource_type_name}' and archived related resources",
          action_timestamp: Time.current
        )
      else
        redirect_to admin_resources_path, alert: 'Failed to delete the resource type.'

        Log.create(
          user_email: current_user.email,
          action: "Failed to Delete Resource Type",
          description: "Attempt to delete resource type '#{resource_type_name}' failed",
          action_timestamp: Time.current
        )
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
  