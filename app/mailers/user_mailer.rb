class UserMailer < ActionMailer::Base
  default :from => "noreply"

  def account_activation(user)
    @user = user
    mail(:to => user.email, :subject => "Activate your account")
  end
  
  def request_password_recovery(user, options = {})
    @user = user
    @ip = options[:ip]
    mail(:to => user.email, :subject => "Password Reminder")
  end
  
  def password_recovery(user, password)
    @user = user
    @password = password
    mail(:to => user.email, :subject => "Password Reminder")
  end
end
