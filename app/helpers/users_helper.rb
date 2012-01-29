module UsersHelper
  def user_icon(user)
    icon = case
    when user.banned?
      user.bans.last.permanent? ? "icons/nuke.png" : "icons/lockdown.png"
    when user.has_icon?
      "#{USER_ICONS_PUB_PATH}/#{user.icon}"
    else
      "icons/default.png"
    end
    image_tag(icon, :class => 'usericon')
  end
  
  def show_photo(user)
    if user.has_photo?
      image_tag("#{USER_PHOTOS_PUB_PATH}/#{user.photo}", :class => 'userphoto')
    else
      content_tag(:i, 'None uploaded.')
    end
  end
  
  def show_status(user)
    status = user.detailed_status
    
    status += if is_mod?
      " | " + 
      case
      when user.banned?
        link_to 'Unban', unban_user_path(:username => user.username)
      when user.unactivated?
        link_to('Activate', activate_user_path(user, :key => user.activation_key)) + " | " +
        link_to('Resend Activation Email', resend_activation_path(user))
      else
        link_to 'Ban', new_ban_path(:username => user.username)
      end
    end.to_s
    
    status.html_safe
  end
end
