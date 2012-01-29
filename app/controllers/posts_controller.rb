class PostsController < ApplicationController
  before_filter :logged_in_only
  before_filter :mods_only, :only => [:modify]
  
  def index
    user = params[:username] ? User.find_by_username(params[:username]) : current_user
    if user
      @posts = user.posts.includes(:topic).where("topics.forum_id in (?)", allowed_forums).
        order("posts.id desc").page(params[:page]).per(50)
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def new
    @thread = Topic.find(params[:thread_id])
    if can_reply(@thread)
      @post = Post.new
      if params[:sub_id]
        @quote = @thread.posts.sub_id(params[:sub_id]).includes(:user).first
        if @quote
          @post.body  = "[quote][b]On #{@quote.created_at.strftime('%B %d %Y %H:%M')}, "
          @post.body += "#{@quote.user.username} wrote:[/b]\n#{@quote.body}[/quote]\n"
        end
      end
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    if can_edit(@post)
      if params[:preview]
        @post.body = params[:post][:body]
        @post.smilies = params[:post][:smilies]
        if can_use_html
          @post.html = params[:post][:html]
        end
      end
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def create
    if params[:preview]
      @post = Post.new(params[:post])
      render :new
    else
      @thread = Topic.find(params[:thread_id])
      sub_id = @thread.posts.last.sub_id + 1
      params[:post].merge!(:sub_id => sub_id, :user_id => current_user.id, :ip => request.remote_ip)
      @post = @thread.posts.new(params[:post])
      if @post.save
        redirect_to show_thread_path(params[:thread_id], :page => @post.page)
      else
        redirect_to new_post_path
      end
    end
  end
  
  def update
    if params[:preview]
      self.edit
      render :edit
    else
      @post = Post.find(params[:id])
      params[:post].merge!(:modified_at => Time.now)
      if @post.update_attributes(params[:post])
        redirect_to show_thread_path(params[:thread_id], :page => params[:page])
      else
        redirect_to :back
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Post has been deleted"
    redirect_to :back
  end
  
  def nuke
    post = Post.find(params[:id])
    post.nuke
    redirect_to :back
  end
end
