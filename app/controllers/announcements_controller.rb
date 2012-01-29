class AnnouncementsController < ApplicationController
  before_filter :mods_only
  
  def index
    @announcements = Announcement.order('id desc')
  end
  
  def new
    @announcement = Announcement.new
  end
  
  def edit
    @announcement = Announcement.find(params[:id])
  end
  
  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      redirect_to announcements_path
    end
  end
  
  def update
    @announcement = Announcement.find(params[:id])
    if params[:announcement][:live] == "1"
      Announcement.update_all("live = false", "id != #{@announcement.id}")
    end
    if @announcement.update_attributes(params[:announcement])
      redirect_to announcements_path
    end
  end
  
  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy
    redirect_to announcements_path
  end
  
  def toggle
    @announcement = Announcement.find(params[:id])
    @announcement.turn_off_live if !@announcement.live
    @announcement.toggle!(:live)
    redirect_to announcements_path
  end
end
