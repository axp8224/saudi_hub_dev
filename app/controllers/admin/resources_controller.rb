module Admin
  class ResourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      per_page = params[:per_page] || 10
      @resource_types = ResourceType.all
      @resources = Resource.all

      # Apply filters if parameters are present
      @resources = @resources.where(resource_type_id: params[:resource_type_id]) if params[:resource_type_id].present?
      @resources = @resources.where(status: params[:status]) if params[:status].present?

      if params[:search].present?
        search_query = "%#{params[:search]}%"
        @resources = @resources.where('title ILIKE :search OR description ILIKE :search', search: search_query)
      end

      # Apply pagination once at the end
      @resources = @resources.page(params[:page]).per(per_page)
    end

    def edit
      @resource = Resource.find(params[:id])
      @resource_types = ResourceType.all

      @feedback = @resource.feedback.present?
    end

    def update
      @resource = Resource.find(params[:id])

      # Store original params for detailed logging
      original_values = {
        title: @resource.title,
        description: @resource.description,
        resource_type: @resource.resource_type.title,
        feedback: @resource.feedback || 'No feedback',
        address: @resource.address || 'No address'
      }

      if @resource.update(
        title: params[:resource][:title],
        description: params[:resource][:description],
        resource_type_id: params[:resource][:resource_type_id],
        feedback: params[:resource][:feedback],
        address: params[:resource][:address]
      )

        # Constructing a description of what was changed
        changes = original_values.map do |key, original_value|
          new_value = key == :resource_type ? @resource.resource_type.title : @resource.send(key)
          "#{key} from '#{original_value}' to '#{new_value}'" if original_value != new_value
        end.compact

        change_description = changes.join(', ')

        flash[:success] = t('flash.resource.edit.resource_updated', title: @resource.title)

        Log.create(
          user_email: current_user.email,
          action: 'Updated Resource',
          description: "Updated resource [#{@resource.title}] -> #{change_description}",
          action_timestamp: Time.current
        )

        redirect_to admin_resources_path
      else
        Log.create(
          user_email: current_user.email,
          action: 'Failed to Update Resource',
          description: "Attempted update on resource: #{@resource.title} failed to apply",
          action_timestamp: Time.current
        )
        flash[:alert] = t('flash.resource.edit.update_failed') # doing flash.now and render :edit caused bugs in the view because the @variables don't get populated. Changing to alert and a redirect.
        redirect_to edit_admin_resource_path(@resource)
      end
    end

    def approve
      @resource = Resource.find(params[:id])

      if @resource.update(status: 'active')
        flash[:success] = t('flash.admin.resource.approved', title: @resource.title)
        Log.create(
          user_email: current_user.email,
          action: 'Approved Resource',
          description: "Approved resource [#{@resource.title}] and set status to active",
          action_timestamp: Time.current
        )
        ResourceMailer.approval_notification(@resource).deliver_now
      else
        flash[:alert] = t('flash.resource.edit.update_failed')
      end

      redirect_to admin_resources_path
    end

    def reject
      @resource = Resource.find(params[:id])

      if @resource.update(status: 'rejected')
        flash[:success] = t('flash.admin.resource.rejected', title: @resource.title)
        Log.create(
          user_email: current_user.email,
          action: 'Rejected Resource',
          description: "Rejected resource [#{@resource.title}] and set status to rejected",
          action_timestamp: Time.current
        )
        ResourceMailer.rejection_notification(@resource).deliver_now
      else
        flash[:alert] = t('flash.resource.edit.update_failed')
      end

      redirect_to admin_resources_path
    end

    def archive
      @resource = Resource.find(params[:id])

      if @resource.update(status: 'archived')
        flash[:success] = t('flash.admin.resource.archived', title: @resource.title)
        Log.create(
          user_email: current_user.email,
          action: 'Archived Resource',
          description: "Archived resource [#{@resource.title}]",
          action_timestamp: Time.current
        )
      else
        flash[:alert] = t('flash.resource.edit.update_failed')
      end

      redirect_to admin_resources_path
    end

    def reinstate
      @resource = Resource.find(params[:id])

      if @resource.update(status: 'active')
        flash[:success] = t('flash.admin.resource.reinstated', title: @resource.title)
        Log.create(
          user_email: current_user.email,
          action: 'Reinstated Resource',
          description: "Reinstated resource [#{@resource.title}] to active status",
          action_timestamp: Time.current
        )
      else
        flash[:alert] = t('flash.resource.edit.update_failed')
      end

      redirect_to admin_resources_path
    end

    def destroy
      @resource = Resource.find(params[:id])
      if @resource.destroy
        flash[:success] = t('flash.admin.resource.deleted', title: @resource.title)
        Log.create(
          user_email: current_user.email,
          action: 'Deleted Resource',
          description: "Deleted resource [#{@resource.title}]",
          action_timestamp: Time.current
        )
      else
        flash[:alert] = t('flash.admin.resource.delete_failed')
      end

      redirect_to admin_resources_path
    end

    private

    def admin_only
      return if current_user.role.name == 'admin'

      redirect_to resources_path, alert: t('flash.admin.access_denied')
    end
  end
end
