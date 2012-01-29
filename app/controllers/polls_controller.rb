class PollsController < ApplicationController
  skip_before_filter :touch_active_users, :only => :show
  skip_before_filter :update_last_seen_at, :only => :show
  skip_before_filter :check_ban_expiration, :only => :show
  
  def show
    @poll = Poll.includes(:choices).where(:id => params[:id]).first
    render :layout => false
  end
  
  def new
    @poll = Poll.new
    12.times { @poll.choices.build }
  end
  
  def create
    params[:poll].merge!(:ip => request.remote_ip)
    @poll = Poll.new(params[:poll])
    if @poll.choices.select { |c| c.name.present? }.length.between?(2,12)
      @poll.choices.delete_if { |c| c.name.blank? }
    end
    render :new if !@poll.save
  end

  def vote
    @poll = Poll.find(params[:id])
    ip = request.remote_ip
    if @poll.voted?(ip)
      @title = "Already Voted"
      "Sorry, but it appears you've already voted in poll ##{params[:id]}: <em>\"#{@poll.name}\"</em>"
    else
      @choice = Choice.find(params[:choice_id])
      @vote = @poll.votes.create(:choice_id => params[:choice_id], :ip => ip)
      @title = "Vote Recorded"
    end
  end
end
