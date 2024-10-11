module Admin
  class ResourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      @resource_types = ResourceType.all
      @resources = Resource.all

      @resources = @resources.where(resource_type_id: params[:resource_type_id]) if params[:resource_type_id].present?

      @resources = @resources.where(status: params[:status]) if params[:status].present?

      return unless params[:search].present?

      search_query = "%#{params[:search]}%"
      @resources = @resources.where('title ILIKE :search OR description ILIKE :search', search: search_query)
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
        resource_type_id: params[:resource][:resource_type_id]
      )

        flash[:success] = t('flash.admin.resource_updated', title: @resource.title)
        Log.create(
          user_email: current_user.email,
          action: "Updated Resource",
          description: "Resource: #{@resource.title} updated",
          action_timestamp: Time.current
        )
        redirect_to admin_resources_path
      else
        flash.now[:alert] = t('flash.admin.update_failed')
        Log.create(
          user_email: current_user.email,
          action: "Failed to Update Resource",
          description: "Resource: #{@resource.title} failed to update",
          action_timestamp: Time.current
        )
        render :edit
      end
    end

    private

    def admin_only
      return if current_user.role.name == 'admin'

      redirect_to resources_path, alert: t('flash.admin.access_denied')
    end
  end
end
