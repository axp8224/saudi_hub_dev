class ResourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    per_page = params[:per_page] || 10
    @resources = Resource.where(status: 'active')
    @resource_types = ResourceType.all

    @resources = @resources.where(resource_type_id: params[:resource_type_id]) if params[:resource_type_id].present?

    if params[:search].present?
      @resources = @resources.where('title ILIKE :search OR description ILIKE :search', search: "%#{params[:search]}%")
    end

    @user_is_admin = current_user.role.name == 'admin'
    @address_filter = params[:address].present?

    if @address_filter
      address_coordinates = fetch_coordinates_with_geoapify(params[:address])
      if address_coordinates.present?
        calculate_distances(@resources, address_coordinates)
        @resources = @resources.sort_by { |resource| resource.distance || Float::INFINITY }
      else
        flash.now[:alert] = t('search.invalid_address')
      end
    end

    flash.now[:notice] = t('search.no_results') if @resources.empty?

    # Server-side validation for radius
    if params[:radius].present?
      @radius = params[:radius].to_f
      if @radius <= 0
        flash.now[:alert] = t('search.invalid_radius') # You can add a translation key for this
        @radius = nil
      else
        @resources = @resources.select { |resource| resource.distance && resource.distance <= @radius }
      end
    end

    @resources = Kaminari.paginate_array(@resources).page(params[:page]).per(per_page)
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
      @posts = Resource.where(author: @user)
      if params[:search].present?
        @posts = @posts.where('title ILIKE :search OR description ILIKE :search', search: "%#{params[:search]}%")
      end
      @posts = @posts.page(params[:page]).per(10)
    else
      redirect_to root_path, alert: t('flash.resource.user_posts.only_your_posts')
    end
  end

  def address_suggestions
    if params[:query].present?
      suggestions = fetch_address_suggestions(params[:query])
      render json: suggestions
    else
      render json: [], status: :bad_request
    end
  end

  def fetch_address_suggestions(query)
    api_key = ENV.fetch('GEOAPIFY_API_KEY', nil)
    return [] unless api_key

    encoded_query = URI.encode_www_form_component(query)
    geoapify_url = "https://api.geoapify.com/v1/geocode/autocomplete?text=#{encoded_query}&apiKey=#{api_key}&limit=5"

    response = Net::HTTP.get(URI(geoapify_url))
    parsed_response = JSON.parse(response)

    if parsed_response['features'].present?
      parsed_response['features'].map do |feature|
        feature['properties']['formatted'] # Full address string
      end
    else
      []
    end
  end

  def fetch_coordinates_with_geoapify(address)
    api_key = ENV.fetch('GEOAPIFY_API_KEY', nil)
    return unless api_key

    encoded_address = URI.encode_www_form_component(address)
    geoapify_url = "https://api.geoapify.com/v1/geocode/search?text=#{encoded_address}&apiKey=#{api_key}&limit=1"

    response = Net::HTTP.get(URI(geoapify_url))
    parsed_response = JSON.parse(response)

    if parsed_response['features'] && parsed_response['features'].any?
      coordinates = parsed_response['features'][0]['geometry']['coordinates']
      [coordinates[1], coordinates[0]]
    else
      nil
    end
  end

  def calculate_distances(resources, input_coordinates)
    api_key = ENV.fetch('GEOAPIFY_API_KEY', nil)
    return [] unless api_key

    # Filter resources that have coordinates
    resources_with_coordinates = resources.select do |resource|
      resource.latitude.present? && resource.longitude.present?
    end

    return [] if resources_with_coordinates.empty?

    geoapify_url = "https://api.geoapify.com/v1/routematrix?apiKey=#{api_key}"

    # Prepare sources (input address) and targets (resources)
    sources = [{ location: input_coordinates.reverse }] # Input address as [longitude, latitude]
    targets = # Each resource's coordinates
      resources_with_coordinates.map do |resource|
        { location: [resource.longitude, resource.latitude] }
      end
    request_body = {
      mode: 'drive',
      sources:,
      targets:
    }

    uri = URI(geoapify_url)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = request_body.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    parsed_response = JSON.parse(response.body)

    return [] unless parsed_response['sources_to_targets'].present?

    distances = parsed_response['sources_to_targets'].first # Distances from input address to each resource

    # Assign distances to resources
    resources_with_coordinates.each_with_index do |resource, index|
      distance_info = distances[index]
      resource.distance = distance_info.present? ? distance_info['distance'] / 1609.34 : nil # Convert meters to miles
    end
  end

  def resource_params
    params.require(:resource).permit(:title, :description, :resource_type_id, :address, images: [])
  end
end
