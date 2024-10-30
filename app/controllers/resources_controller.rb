class ResourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    # Filter resources by type if specified
    @resources = @resources.where(resource_type_id: params[:resource_type_id]) if params[:resource_type_id].present?

    @user_is_admin = (current_user.role.name == 'admin')

    # Filter by search query if present
    if params[:search].present?
      @resources = @resources.where('title ILIKE :search OR description ILIKE :search', search: "%#{params[:search]}%")
    end

    flash.now[:notice] = t('search.no_results') if @resources.empty?

    # Paginate the resources
    per_page = params[:per_page] || 10 # Set a default per page value
    @resources = @resources.page(params[:page]).per(per_page)
  end

  def new
    @resource = Resource.new
    @resource_types = ResourceType.all
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.author = current_user

    @resource.status = 'pending'

    if @resource.save
      flash[:success] = t('flash.resource.create_success')
      redirect_to resources_path

      Log.create(
        user_email: current_user.email,
        action: 'Created Resource Proposal',
        description: "Created new resource proposal titled '#{@resource.title}' with description '#{@resource.description}'",
        action_timestamp: Time.current
      )

    else
      @resource_types = ResourceType.all
      render :new

      Log.create(
        user_email: current_user.email,
        action: 'Failed to Create Resource Proposal',
        description: 'Attempt to create new resource proposal failed',
        action_timestamp: Time.current
      )
    end
  end

  def show
    @resource = Resource.find(params[:id])
    @resource_author = User.find(@resource.user_id) if @resource.user_id.present?
  end

  def edit
    @resource = Resource.find(params[:id])

    if @resource.author != current_user
      redirect_to root_path, alert: t('flash.resource.edit.only_your_posts')
    elsif @resource.status != 'pending'
      redirect_to root_path, alert: t('flash.resource.edit.only_pending')
    else

    end
  end

  def update
    @resource = Resource.find(params[:id])
    original_values = {
      title: @resource.title,
      description: @resource.description,
      resource_type_id: @resource.resource_type_id,
      feedback: @resource.feedback
    }
    if @resource.update(resource_params)
      changes = []
      original_values.each do |key, original_value|
        new_value = @resource.send(key)
        changes << "#{key} changed from '#{original_value}' to '#{new_value}'" if original_value != new_value
      end

      Log.create(
        user_email: current_user.email,
        action: 'User Resource Proposal Updated',
        description: "User resource proposal [#{@resource.title}] updated: #{changes.join(', ')}",
        action_timestamp: Time.current
      )
      flash[:success] = t('flash.resource.edit.resource_updated', title: @resource.title)
      redirect_to posts_user_path(current_user)
    else
      Log.create(
        user_email: current_user.email,
        action: 'Resource Proposal Update Failed',
        description: "Failed to update resource propsal [#{@resource.title}]",
        action_timestamp: Time.current
      )
      redirect_to posts_user_path(current_user), alert: t('flash.resource.edit.update_failed')
    end
  end

  def user_posts
    @user = User.find(params[:id])

    if @user == current_user
      @posts = Resource.where(author: @user).page(params[:page]).per(10) # Adjust the number per page as needed
    else
      redirect_to root_path, alert: t('flash.resource.user_posts.only_your_posts')
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :description, :resource_type_id, images: [])
  end
end
