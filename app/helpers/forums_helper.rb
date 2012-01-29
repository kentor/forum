module ForumsHelper
  def thread_status(thread)
    image_tag "icons/#{thread.status}"
  end
  
  def jump_to_last_page(thread)
    last_page = thread.total_pages
    if last_page > 1 
      link = link_to raw("&gt;"), show_thread_path(thread, :page => last_page.ceil),
        :class => 'jump size10', :title => "Jump to last page"
      " #{link}".html_safe
    end
  end
end
