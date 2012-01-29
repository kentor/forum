class IconsController < ApplicationController
  before_filter :mods_only
  before_filter :admins_only, :only => [:create, :destroy]
  
  def index
    @icons = Icon.all
  end
  
  def create
    file = File.new("#{USER_ICONS_PATH}/#{params[:icon].original_filename}", "wb")
    file.write(params[:icon].read)
    file.close
    redirect_to icons_path
  end

  def destroy
    file = "#{USER_ICONS_PATH}/#{params[:icon]}"
    File.delete(file) if File.exists?(file)
    redirect_to icons_path
  end
end
