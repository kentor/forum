class BansController < ApplicationController
  before_filter :mods_only, :except => [:index]
  
  def index
    if params[:username]
      @user = User.find_by_username(params[:username])
      if @user
        bans = @user.bans.order('id desc')
        @title = "Ban History for #{@user.username} (#{bans.size})"
      else
        flash[:error] = "User does not exist"
        redirect_to :back
      end
    else
      if params[:type].blank?
        bans = Ban.where('permanent = false AND expires_at > ?', Time.now).order('expires_at asc')
      elsif params[:type] == 'perm'
        bans = Ban.where(:permanent => true).order('id desc')
      end
      @title = "List of " + (params[:type].blank? ? 'Temp' : 'Perm') + " Bans (#{bans.size})"
    end
    @bans = bans.includes(:user).includes(:banner).includes(:post).page(params[:page]).per(50)
  end
  
  def create
    user = User.find_by_username(params[:ban][:username])
    if user.nil?
      flash[:error] = "User does not exist"
      redirect_to new_ban_path
    else
      user.unban if user.bans.last
      t = Time.now
      dur_hash = {:'2 days' => t+2.days, :'1 week' => t+1.week, :'2 weeks' => t+2.weeks,
        :'30 days' => t+30.days, :'60 days' => t+60.days, :'90 days' => t+90.days, :Permanent => ''}
      duration = dur_hash[params[:ban][:duration].to_sym]
      post_duration = duration.present? ? "temp banned for #{params[:ban][:duration]}" : "banned"
      reason = params[:ban][:reason] == 'other' ? params[:ban][:other_reason] : params[:ban][:reason]
      @thread = Topic.find(settings.ban_thread)
      @ban = user.bans.new(:banner_id => current_user.id,
        :post_id    => (params[:post_id] if params[:post_ban]),
        :duration   => params[:ban][:duration],
        :reason     => reason,
        :permanent  => (duration.blank?),
        :expires_at => (duration.blank? ? t : duration))
      @post = @thread.posts.new(:sub_id => (@thread.posts.last.sub_id+1),
        :user_id => settings.bot_id,
        :body    => "[b]#{user.username}[/b] was just [b]#{post_duration}[/b] by #{current_user.username}.\n\nThat account was created on [b]#{user.created_at.strftime("%B %d %Y %H:%M")}[/b] and had [b]#{user.posts.count.to_s}[/b] posts.\n\n[b]Reason:[/b] #{reason}",
        :ip      => request.remote_ip)
      if user.ban && @ban.save && @post.save && @thread.update_attribute(:title, "Automated Ban List [Latest: #{user.username}]")
        if params[:post_ban]
          post = Post.find(params[:post_id])
          post.ban!(:temporary => duration.present?)
          redirect_to show_thread_path(post.topic_id, :page => params[:page])
        else
          redirect_to show_user_path(:username => params[:ban][:username])
        end
      else
        redirect_to new_ban_path
      end
    end
  end
  
  def unban
    @user = User.find_by_username(params[:username])
    @user.unban if @user
    redirect_to :back
  end
end
