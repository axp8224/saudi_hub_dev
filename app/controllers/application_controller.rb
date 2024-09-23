class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  def switch_locale
    locale = params[:locale]
    cookies[:locale] = locale
    redirect_to request.referer || root_path
  end
end