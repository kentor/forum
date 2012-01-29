class ApplicationController < ActionController::Base
  include Rack::Recaptcha::Helpers

  protect_from_forgery
  before_filter :touch_active_users
  before_filter :update_last_seen_info, :if => :current_user
  before_filter :check_ban_expiration, :if => :current_user_banned?
  
  layout 'application'
  
  helper :announcements, :bbcode, :messages
  helper_method :allowed_forums, :current_user, :can_view, :can_read, :can_reply, :can_create,
    :can_pm, :can_quote, :can_edit, :can_use_html, :is_admin?, :is_mod?, :is_staff?, :recaptcha_tag
  
  def allowed_forums(select = false)
    Forum.scoped.collect do |forum|
      select ? [forum.title, forum.id] : forum.id if can_view(forum)
    end.compact
  end
  
  private
  
  def settings
    @settings ||= Setting.first
  end
  
  def current_user
    @current_user ||= session[:user] && User.find(session[:user]) || cookies[:user] && User.find(cookies.signed[:user])
  end
  
  def current_user_banned?
    @current_user_banned ||= current_user && current_user.banned?
  end
  
  def check_ban_expiration
    last_ban = current_user.bans.last
    current_user.unban if !last_ban.permanent? && last_ban.expires_at < Time.now
  end
  
  def intersect(string1, string2 = current_user.groups)
    (string1.split(',') & string2.split(',')).any?
  end
  
  def can_use_html
    current_user && intersect(settings.html_groups)
  end
  
  def is_admin?
    current_user && intersect(settings.admin_groups)
  end
  
  def is_mod?
    current_user && intersect(settings.mod_groups)
  end
  
  def is_staff?
    current_user && intersect(settings.staff_groups)
  end
  
  def can_view(forum)
    forum.can_view.blank? || (current_user && !current_user.banned? && intersect(forum.can_view))
  end
  
  def can_read(forum)
    forum.can_read.blank? || (current_user && !current_user.banned? && intersect(forum.can_read))
  end
  
  def can_reply(thread, forum = thread.forum)
    current_user && !current_user.banned? && !current_user.unactivated? && intersect(forum.can_reply) && (!thread.locked? || is_mod?)
  end
  
  def can_create(forum)
    current_user && !current_user.banned? && !current_user.unactivated? && intersect(forum.can_create)
  end
  
  def can_pm
    current_user && !current_user.banned?
  end
  
  def can_quote(post, thread = post.topic, forum = thread.forum)
    is_mod? || (!post.nuked? && can_reply(thread, forum))
  end
  
  def can_edit(post, thread = post.topic, forum = thread.forum)
    is_mod? || (!post.nuked? && !thread.locked? && (can_reply(thread, forum) || can_create(forum)) && current_user.id == post.user_id)
  end
  
  def admins_only
    render NOT_ENOUGH_RIGHTS if !is_admin?
  end
  
  def mods_only
    render NOT_ENOUGH_RIGHTS if !is_mod?
  end
  
  def staff_only
    render NOT_ENOUGH_RIGHTS if !is_staff?
  end
  
  def logged_in_only
    render NOT_ENOUGH_RIGHTS if !current_user
  end
  
  def touch_active_users
    Session.touch_active_users(request.remote_ip)
  end
  
  def update_last_seen_info
    current_user.update_last_seen_info(:ip => request.remote_ip)
  end
end
