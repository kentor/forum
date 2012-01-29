class SettingsController < ApplicationController
  before_filter :admins_only
  
  def index
    @settings = settings
  end
  
  def update
    if settings.update_attributes(params[:settings])
      flash[:notice] = 'Settings updated'
    end
    redirect_to settings_path
  end
end
