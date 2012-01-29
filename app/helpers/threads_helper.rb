module ThreadsHelper
  def unable_to_post(thread)
    case 
    when thread.locked?
      "This thread has been locked by a moderator."
    when current_user.banned?
      "You have been banned and may not post."
    when current_user.unactivated?
      "You must activate your account before you can post."
    else
      "Not enough permissions to reply."
    end
  end
end
