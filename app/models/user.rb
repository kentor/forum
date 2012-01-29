class User < ActiveRecord::Base
  has_secure_password

  has_many :posts
  has_many :topics
  has_many :messages
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id'
  has_many :logins
  has_many :warnings
  has_many :bans

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false },
    :length => { :maximum => 20 }, :format => /\A[\w\s\d\[\]\(\)\'\.\-]*\Z/
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
    :length => { :maximum => 70 }, :format => /\A[^@\s]+@[a-z0-9-]+\.[a-z\.]{2,}\Z/i
  validates :location, :length => { :maximum => 30 }
  validate :captcha, :on => :create

  attr_accessor :valid_captcha

  before_validation do
    username.strip! if username
    email.strip! if email
  end

  def self.logged_in(time = 15.minutes.ago)
    where("last_seen_at >= ?", time)
  end
  
  def self.search(username, email, groups, registip)
    where("username like ? and email like ? and groups like ? and registration_ip like ?",
      "%#{username}%", "%#{email}%", "%#{groups}%", "%#{registip}%")
  end
  
  def update_last_seen_info(options = {})
    User.record_timestamps = false
    update_attributes(:last_seen_at => Time.now, :last_seen_ip => options[:ip])
    User.record_timestamps = true
  end
  
  def status
    case
    when banned?      then " (Banned)"
    when unactivated? then " (Unactivated)"
    end
  end
  
  def detailed_status
    case
    when banned?
      last_ban = bans.last
      if last_ban.permanent?
        "Perm Banned"
      else
        "Temp Banned, expires on #{last_ban.expires_at.strftime("%B %d %Y %H:%M")}"
      end
    when unactivated? then "Unactivated"
    else "Standard"
    end
  end

  def styled_name
    username_re = /\#\{username\}/i
    return username unless username_style =~ username_re
    username_style.gsub(username_re, username).html_safe
  end
  
  def show_birthday
    birthday.strftime("%B %d#{", %Y" if birthday.year != 1}") if birthday.present?
  end
  
  def avg_posts(per_time = 1.day)
    (posts.size / ((Time.now - created_at) / per_time)).round(2).to_s
  end
  
  def recent_posts(time = 1.week.ago)
    posts.select { |p| p.created_at >= time }
  end
  
  def photo
    "#{id}.#{photo_type}"
  end
  
  def has_photo?
    photo_type.present? && File.exists?("#{USER_PHOTOS_PATH}/#{photo}")
  end
  
  def store_photo(image_file, file_extension)
    file = File.new("#{USER_PHOTOS_PATH}/#{id}.#{file_extension}", "wb")
    return false if file.nil? || !file.write(image_file.read)
    file.close
    update_attribute(:photo_type, file_extension)
  end
  
  def remove_photo
    file = "#{USER_PHOTOS_PATH}/#{id}.#{photo_type}"
    File.delete(file) if File.exists?(file)
    update_attribute(:photo_type, nil)
  end
  
  def has_icon?
    icon.present? && File.exists?("#{USER_ICONS_PATH}/#{icon}")
  end
  
  def unactivated?
    activation_key.present?
  end
  
  def activate(key)
    return false if activation_key != key
    update_attribute(:activation_key, nil)
  end
  
  def ban
    update_attribute('banned', true)
  end
  
  def unban
    bans.last.update_attributes(:permanent => false, :expires_at => Time.now)
    update_attribute('banned', false)
  end
  
  def warnings_and_bans
    (bans.includes(:banner).includes(:post) + warnings.includes(:warner).includes(:post)).sort do |a,b|
      b.created_at <=> a.created_at
    end
  end
  
  def set_new_password(key)
    return false if recovery_key != key
    password = SecureRandom.hex(3)
    UserMailer.password_recovery(self, password).deliver
    update_attributes(:password => password, :recovery_key => nil)
  end
  
  def captcha
    unless self.valid_captcha
      self.errors.add(:base, "Incorrect captcha")
    end
  end
  
  def self.detailed
    includes(:logins).includes(:posts).includes(:bans).includes(:warnings)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  def send_request_password_recovery(options = {})
    UserMailer.request_password_recovery(self, options).deliver
  end
end
