class PagesController < ApplicationController
  # responsible for static pages
  before_action :authenticate_user!, only: [:documentation]
  before_action :admin_only, only: [:documentation]

  def home
  end

  def help 
  end

  def documentation 
  end

  private
  def admin_only
    return if current_user.role.name == 'admin'
    redirect_to root_path, alert: t('flash.admin.access_denied')
  end
end
