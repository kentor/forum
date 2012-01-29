class UsersController < ApplicationController
  before_filter :logged_in_only, :only => [:edit, :update]
  before_filter :staff_only, :only => [:index, :show_detailed]
  before_filter :mods_only, :only => [:edit_detailed, :update_detailed]
  
  def index
    users = User.search(params[:u], params[:e], params[:g], params[:r])
    if params[:ip].present?
      users = users.joins(:logins).where("ip like ?", "%#{params[:ip]}%").group("users.id")
    end
    @users = users.page(params[:page]).per(50)
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
  end
   
  def show
    @user = User.find_by_username(params[:username])
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to root_path
    end
  end
  
  def create
    @user = User.new(:username => params[:user][:username],
      :password              => params[:user][:password],
      :password_confirmation => params[:user][:password_confirmation],
      :email                 => params[:user][:email],
      :location              => params[:user][:location],
      :registration_ip       => request.remote_ip,
      :activation_key        => SecureRandom.hex(2),
      :valid_captcha         => recaptcha_valid?
    )
      
    if @user.save
      @user.send_activation_email
      flash[:notice] = "Registered! Check your email for instructions on activating your account."
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @user = current_user
    @errors = Array.new
    
    if params[:photo]
      if params[:photo].size <= 256000
        file_extension = ''

        mime_type = params[:photo].content_type.strip.gsub!('image/', '')
        
        if !mime_type.nil?
          case mime_type.to_sym
          when :jpeg
            file_extension = 'jpg'
          when :jpg, :png, :gif
            file_extension = mime_type
          end
        end

        if file_extension.present?
          @user.remove_photo
          @user.store_photo(params[:photo], file_extension)
        else
          @errors << "Incorrect photo format"
        end
      else
        @errors << "Your photo is too big, max size is 256kb"
      end
    elsif params[:remove_photo]
      @user.remove_photo
    end

    if @user.update_attributes(params[:user]) && @errors.blank?
      flash[:notice] = "Updated profile"
      redirect_to show_profile_path(:username => @user.username)
    else
      @errors << @user.errors.full_messages
      render :edit
    end
  end
  
  def show_detailed
    @user = User.detailed.find_by_username(params[:username])    
    if @user.logins.size > 0
      @ips = @user.logins.collect(&:ip).uniq
      @logins = Login.includes(:user).where("ip in (?) and user_id != ?", @ips, @user.id).
        group('user_id').recent
      @other_logins = @logins.collect { |l| l.user.username }
    else
      @ips = @other_logins = Array.new
    end
  end
  
  def edit_detailed
    @user = User.find_by_username(params[:username])
  end
  
  def update_detailed
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "User info saved"
      redirect_to edit_user_path(:username => params[:user][:username])
    else
      render :edit_detailed
    end
  end
  
  def activate
    @user = User.find(params[:id])
    if @user.activate(params[:key])
      flash[:notice]  = "Your account #{@user.username} has been activated"
    else
      flash[:error] = "Account activation failed"
    end
    redirect_to root_path
  end
  
  def request_password
    if request.post?
      @user = User.find_by_username(params[:username])
      if @user
        @user.update_attribute(:recovery_key, SecureRandom.hex(2))
        @user.send_request_password_recovery(:ip => request.remote_ip)
        flash[:notice] = "Please follow the steps sent to your email"
        redirect_to root_path
      else  
        flash[:error] = "User does not exist"
      end
    end
  end
  
  def recover_password
    @user = User.find(params[:id])
    if @user.set_new_password(params[:key])
      flash[:notice] = "A new password has been emailed to you"
    else
      flash[:error] = "Password recovery failed"
    end
    redirect_to root_path
  end
  
  def resend_activation
    @user = User.find(params[:id])
    if @user
      @user.send_activation_email
      flash[:notice] = "Resent activation email"
    else
      flash[:error] = "User not found"
    end
    redirect_to :back
  end
end
