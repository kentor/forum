module PostsHelper
  def display_post(post)
    body = post.nuked? ? NUKED_MESSAGE : bb(post.body, :smilies => post.smilies, :html => post.html)
    
    if post.warned? || post.banned?
      body += "<br>\n<br>\n<span style='color:red' class='bold'>".html_safe
      body += "User was #{post.warned? ? 'warned' : (('temp ' if post.temp_banned).to_s + 'banned')} for this post.</span>".html_safe
    end
    
    body.html_safe
  end
end
