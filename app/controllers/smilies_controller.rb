class SmiliesController < ApplicationController
  before_filter :mods_only
  
  def index
    @smilies = Smiley.order('filename asc')
  end
  
  def create
    if Smiley.store(params[:smiley], params[:code])
      flash[:notice] = 'Smiley created'
    end
    redirect_to smilies_path
  end

  def destroy
    @smiley = Smiley.find_by_filename(params[:filename])
    if @smiley.remove
      flash[:notice] = 'Smiley deleted'
    end
    redirect_to smilies_path
  end
end
