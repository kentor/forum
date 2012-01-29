class MessagesController < ApplicationController
  before_filter :logged_in_only
  
  helper_method :your_pm?
  
  def index
    @messages = current_user.received_messages.includes(:user).page(params[:page]).per(20)
  end
    
  def outbox
    @messages = current_user.messages.includes(:recipient).page(params[:page]).per(20)
  end
  
  def show
    @message = Message.find(params[:id])
    if your_pm?(@message) || @message.user_id == current_user.id
      @message_sender = @message.user.username
      if your_pm?(@message) && !@message.read?
        @message.update_attribute(:read, true)
      end
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def new
    if can_pm
      @message = Message.new
      if params[:reply]
        @reply = Message.find(params[:reply])
        if your_pm?(@reply)
          @message.subject = "#{'Re: ' unless @reply.subject =~ /^Re:/i}#{@reply.subject}"
          @message.body = "\n\n\n#{'-'*41}\nOriginal Message:\n#{@reply.body}"
        else
          render NOT_ENOUGH_RIGHTS
        end
      end
    else
      render NOT_ENOUGH_RIGHTS
    end
  end
  
  def create
    @recipient = User.find_by_username(params[:message][:recipient])
    if @recipient.nil?
      flash[:error] = "User does not exist"
      params[:message][:recipient] = nil
      @message = current_user.messages.new(params[:message])
      render :new
    else
      @message = current_user.messages.new(:recipient_id => @recipient.id,
        :subject  => params[:message][:subject],
        :body     => params[:message][:body],
        :ip       => request.remote_ip)
      if @message.save
        redirect_to sent_messages_path
      else
        render :new
      end
    end
  end
  
  def toggle
    @message = current_user.received_messages.find(params[:id])
    @message.update_attribute(:read, !@message.read?)
    redirect_to messages_path
  end
  
  private
  
  def your_pm?(message)
    message.recipient_id == current_user.id
  end
end
