module MessagesHelper
  def pm
    pm_count = current_user.received_messages.where("`messages`.read = ?", false).size
    pm_link = link_to 'PM', messages_path
    if pm_count > 0
      %{<span class="bold coloryellow">#{pm_count} #{image_tag('icons/new.gif')} #{pm_link}</span>}.html_safe
    else
      pm_link
    end
  end
end
