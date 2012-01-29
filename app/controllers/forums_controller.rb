class ForumsController < ApplicationController
  before_filter :admins_only, :only => [:new, :create, :edit, :update, :destroy, :sort]
  
  def index
    @forums = Forum.scoped.select { |forum| can_view(forum) && forum.threads_in_index != 0 }
  end
  
  def search
    if params[:q]
      if params[:u].present?
        @user = User.find_by_username(params[:u])
        flash[:error] = "User does not exist" unless @user
      end
      if params[:q].strip.length < 3 && !@user
        flash[:error] = 'Query must be longer than 3 characters'
        redirect_to search_path
      else
        @forums = (params[:f].present? && allowed_forums.include?(params[:f].to_i)) ? params[:f] : allowed_forums
        case params[:t]
        when "c"
          @posts = Post.search(params[:q]).joins(:topic).
            where("topics.forum_id in (?)", @forums).order("posts.id desc")
          @posts = @posts.where("posts.user_id = ?", @user.id) if @user
          @posts = @posts.page(params[:page]).per(100)
          thread_ids = @posts.collect(&:topic_id).uniq
          @threads = Topic.list.includes(:forum).where("id in (?)", thread_ids).forum_id(@forums).
            order("Field(id,#{thread_ids.join(',')})")
        else
          @threads = Topic.list.includes(:forum).forum_id(@forums).
            search(params[:q]).order('last_posted_at desc')
          @threads = @threads.where(:user_id => @user.id) if @user
          @threads = @threads.page(params[:page]).per(100)
        end
      end
    end
  end
  
  def show
    @forum = Forum.find(params[:id])
    if can_view(@forum)
      @threads = @forum.topics.list.page(params[:page]).per(@forum.threads_in_forum)
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def edit
    @forum = Forum.find(params[:id])
  end
  
  def new
    @forum = Forum.new(:position => Forum.last.position + 1)
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to forums_path
    else
      render :new
    end
  end
  
  def update
    @forum = Forum.find(params[:id])
    @forum.update_attributes(params[:forum])
    redirect_to forums_path
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    if request.post?
      if @forum.destroy && @forum.topics.update_all("forum_id = #{params[:forum][:id]}")
        redirect_to forums_path
      else
        redirect_to :back
      end
    end
  end
  
  def sort
    params[:forum].each_with_index do |id, index|
      Forum.update_all(["position = ?", index + 1], ["id = ?", id])
    end
    render :nothing => true
  end
end
