class ThreadsController < ApplicationController
  before_filter :mods_only, :only => [:edit, :update, :destroy]
  
  def show
    @thread = Topic.find(params[:id])
    @forum = @thread.forum
    if can_read(@forum)
      @thread.increment_views
      @posts = @thread.posts.includes(:user).order("id").page(params[:page]).per(20)
      @post = @thread.posts.new
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def edit
    @thread = Topic.find(params[:id])
  end
  
  def new
    @forum = Forum.find(params[:forum_id])
    if can_create(@forum)
      @thread = Topic.new
      @post = @thread.posts.new
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def create
    @forum = Forum.find(params[:forum_id])
    if params[:preview]
      @thread = Topic.new(params[:thread])
      @post = Post.new(params[:post])
      render :new
    else
      @thread = @forum.topics.new(:user_id => current_user.id,
        :title  => params[:thread][:title],
        :ip     => request.remote_ip)
      params[:post].merge!(:sub_id => 1, :user_id => current_user.id,
        :is_thread => true, :ip => request.remote_ip)
      @post = @thread.posts.build(params[:post])
      if @thread.save
        redirect_to show_thread_path(@thread)
      else
        render :new
      end
    end
  end
    
  def update
    @thread = Topic.find(params[:id])
    if @thread.update_attributes(params[:thread])
      redirect_to show_thread_path(@thread)
      flash[:notice] = "Thread has been updated"
    end
  end
  
  def destroy
    @thread = Topic.find(params[:id])
    @thread.destroy
    flash[:notice] = "Thread titled <u>#{@thread.title}</u> has been deleted".html_safe
    redirect_to show_forum_path(@thread.forum)
  end
end
