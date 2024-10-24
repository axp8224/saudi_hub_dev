class ResourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    # Filter resources by type if specified
    @resources = @resources.where(resource_type_id: params[:resource_type_id]) if params[:resource_type_id].present?

    @user_is_admin = ( current_user.role.name == 'admin' )

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
    else
      @resource_types = ResourceType.all
      render :new
    end
  end

  def show
    @resource = Resource.find(params[:id])
    @resource_author = User.find(@resource.user_id) if @resource.user_id.present?
  end

  def edit 
    @resource = Resource.find(params[:id])

    if @resource.author != current_user
      redirect_to root_path, alert: t("flash.resource.edit.only_your_posts") 
    elsif @resource.status != 'pending'
      redirect_to root_path, alert: t("flash.resource.edit.only_pending")
    else
      
    end

  end

  def update 
    @resource = Resource.find(params[:id])
    if @resource.update(resource_params)
      flash[:success] = t('flash.resource.edit.resource_updated', title: @resource.title)
      redirect_to posts_user_path(current_user)
    else
      redirect_to posts_user_path, alert: t('flash.resource.edit.update_failed')
    end

  end

  def user_posts 
    @user = User.find(params[:id])

    if @user == current_user 
      @posts = Resource.where(author: @user)
    else 
      redirect_to root_path, alert: t(".only_your_posts") 
    end

  end

  private

  def resource_params
    params.require(:resource).permit(:title, :description, :resource_type_id, images: [])
  end

end
