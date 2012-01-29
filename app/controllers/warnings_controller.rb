class WarningsController < ApplicationController
  before_filter :mods_only

  def new
    body  = "This is a Warning!\n\n\n\nThanks in advance for your cooperation,\n"
    body += "The Mod Staff.\n\n(Do not reply to this message. No one will receive it.)"
    @warning = Warning.new
    @message = Message.new(:subject => 'Warning!', :body => body)
  end
  
  def create
    @post = Post.find(params[:post_id])
    @warning = Warning.new(:user_id => @post.user_id,
      :warner_id => current_user.id,
      :post_id   => (params[:post_id] if params[:post_warn]),
      :message   => params[:message][:body])
    @message = Message.new(:user_id => Setting.first.bot_id,
      :recipient_id => @post.user_id,
      :subject      => params[:message][:subject],
      :body         => params[:message][:body],
      :ip           => request.remote_ip)
    if @warning.save && @message.save
      @post.warn! if params[:post_warn]
      flash[:notice] = "Successfully warned user #{params[:username]}"
      redirect_to show_thread_path(@post.topic_id, :page => params[:page])
    end
  end
end
