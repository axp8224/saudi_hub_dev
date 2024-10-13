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

      @feedback = @resource.feedback.present?
    end

    def update
      @resource = Resource.find(params[:id])

      # Store original params for detailed logging
      original_title = @resource.title
      original_description = @resource.description
      original_status = @resource.status
      original_resource_type_id = @resource.resource_type_id
      original_feedback = @resource.feedback.present? ? @resource.feedback : "No feedback"

      if @resource.update(
        status: params[:resource][:status],
        title: params[:resource][:title],
        description: params[:resource][:description],
        resource_type_id: params[:resource][:resource_type_id],
        feedback: params[:resource][:feedback]
      )

      # Constructing a description of what was changed
      changes = []
      changes << "title from '#{original_title}' to '#{@resource.title}'" if @resource.title != original_title
      changes << "description from '#{original_description}' to '#{@resource.description}'" if @resource.description != original_description
      changes << "status from '#{original_status}' to '#{@resource.status}'" if @resource.status != original_status
      changes << "resource type from '#{original_resource_type_id}' to '#{@resource.resource_type_id}'" if @resource.resource_type_id != original_resource_type_id
      changes << "feedback from '#{original_feedback}' to '#{@resource.feedback}'" if @resource.feedback.present? && @resource.feedback != original_feedback

      change_description = changes.join(", ")

      flash[:success] = t('flash.admin.resource_updated', title: @resource.title)

      Log.create(
        user_email: current_user.email,
        action: "Updated Resource",
        description: "Updated resource [#{@resource.title}] -> #{change_description}",
        action_timestamp: Time.current
      )
      redirect_to admin_resources_path
      else
        flash.now[:alert] = t('flash.admin.update_failed')
        Log.create(
          user_email: current_user.email,
          action: "Failed to Update Resource",
          description: "Attempted update on resource: #{@resource.title} failed to apply",
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
