class MiscController < ApplicationController
  before_filter :staff_only, :only => [:stats]
  
  def stats
    @stats = { 'Forums' => Forum, 'Threads' => Topic, 'Posts' => Post,
      'Users' => User, 'Bans' => Ban, 'PMs' => Message }
  end
end
