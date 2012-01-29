class SessionsController < ApplicationController
  before_filter :staff_only, :only => [:index]
    
  def index
    @users = User.logged_in.includes(:logins).order('last_seen_at desc')
  end
  
  def new
    if current_user
      redirect_to root_path
    else
      if request.post?
        user = User.find_by_username(params[:login][:username])
        if user && user.authenticate(params[:login][:password])
          params[:remember_me] ? cookies.permanent.signed[:user] = user : session[:user] = user.id
          logins = user.logins.create(:ip => request.remote_ip)
          redirect_to "/" + session[:last_page].to_s
          session.delete(:last_page)
        else
          flash[:error] = "Wrong login information"
        end
      else
        uri = (request.env['HTTP_REFERER'] || "").split('/', 4).last
        session[:last_page] = uri unless uri =~ %r{^(login|users/create)$}i
      end
    end
  end

  def destroy
    cookies.delete(:user)
    session.delete(:user)
    redirect_to root_path
  end
end
