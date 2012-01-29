class AdminController < ApplicationController
  before_filter :staff_only
  before_filter :admins_only, :only => [:forums]
  
  def forums
    @forums = Forum.scoped
  end
end
