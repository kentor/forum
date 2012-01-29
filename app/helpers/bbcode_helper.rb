module BbcodeHelper
  def parse_nested(text)
    text = text.gsub(/\[code\](.*?)\[\/code\]/im) do
      body = $1.gsub("[", "&#91;").gsub("]", "&#93;").gsub("<", "&lt;").gsub(">", "&gt;")
      %{[nobreak]<pre style="margin:0">#{body}</pre>[/nobreak]}
    end
    text = text.gsub(/\[b\](.*?)\[\/b\]/im, '<strong>\1</strong>')
    text = text.gsub(/\[i\](.*?)\[\/i\]/im, '<em>\1</em>')
    text = text.gsub(/\[u\](.*?)\[\/u\]/im, '<u>\1</u>')
    text = text.gsub(/\[s\](.*?)\[\/s\]/im, '<s>\1</s>')
    text = text.gsub(/\[center\](.*?)\[\/center\]/im, '<center>\1</center>')
    text = text.gsub(/\[red\](.*?)\[\/red\]/im, '<span style="color:red">\1</span>')
    text = text.gsub(/\[green\](.*?)\[\/green\]/im, '<span style="color:green">\1</span>')
    text = text.gsub(/\[blue\](.*?)\[\/blue\]/im, '<span style="color:blue">\1</span>')
    text = text.gsub(/\[quote\](.*?)\[\/quote\]/im, '<div class="bbquote">\1</div>')
    text = text.gsub(/\[spoiler(?:="?(.*?)"?)?\](.*?)\[\/spoiler\]/im) do
      a  = "<a href='#' class='spoiler monospace' title='#{$1}'>+ Show Spoiler "
      a += "[#{$1}] " if $1
      a += "+</a><div class='bbspoiler'>#{$2}</div>"
    end
  end
  
  def parse_inline(text)
    text = text.gsub(/\[list(?:="?(ordered)"?)?\](.*?)\[\/list\]/im) do
      ordered, content = $1, $2.gsub("[*]", "<li>")
      "[nobreak]" + (ordered ? "<ol>#{content}</ol>" : "<ul>#{content}</ul>") + "[/nobreak]"
    end
    text.gsub!(/\r?\n/, "<br />\n")
    text.gsub!(/\[nobreak\](.*?)\[\/nobreak\]/im) do
      $1.gsub("<br />", "")
    end
    text.gsub!(/\[poll\](\d+)\[\/poll\]/i) do
      id = $1
      content_tag(:div, "<script>jQuery.ajax({url:'/poll/#{id}',success:function(data){$('div[data-poll=#{id}]').html(data)},async:false})</script>".html_safe, "class" => "poll size12", "data-poll" => id)
    end
    text.gsub!(/\[img\](.*?)\[\/img\]/i) { image_tag($1, :class => 'bbimg') }
    text.gsub!(/\[url(?:="?(.*?)"?)?\](.*?)\[\/url\]/i) { link_to($2, $1 || $2, :target => "_blank") }
    text.gsub!(/magnet:\?([^\s\['"<]+)/i) { link_to($&, $&) }
    text = text.gsub(%r{(?:http://)?(?:www\.)?youtube\.com/watch\?v=([^\s\['"<]+)}i) do
      left, href, v = $`, $&, $1
      if left =~ /(?:"|#{Regexp.escape(v)}">)$/
        href
      else
        if v =~ /\#t=(\d+)m(\d+)s$/
          id, min, sec = $`, $1.to_i, $2.to_i
          time = min*60 + sec
          v = "#{id}&amp;start=#{time}"
        end
        %{<object type="application/x-shockwave-flash" data="http://www.youtube.com/v/#{v}"
        width="480" height="388" title="Click to play#{" (will start at #{min} min, #{sec} sec)" if $2}">
        <param name="movie" value="http://www.youtube.com/v/#{v}"><param name="wmode" value="transparent">
        <param name="allowFullScreen" value="true"></object>}
      end
    end
  end
  
  def smilize(text)
    @smilies ||= {}
    Smiley.scoped.each { |smiley| @smilies[smiley.code] = smiley.filename } if @smilies.empty?
    @smilies.each_pair do |code, filename|
      text.gsub!(/#{Regexp.escape(code)}/i, image_tag("/smilies/#{filename}", :class => 'bbsmiley'))
    end
    text
  end
  
  def bb(text, options = {})
    options.reverse_merge! :smilies => true, :html => false
    
    unless options[:html]
      text = text.gsub("<", "&lt;").gsub(">", "&gt;")
    end
    
    parsed_nested = parse_nested(text)
    if parsed_nested != text
      bb parsed_nested, :smilies => options[:smilies], :html => true
    else
      text = auto_link(parse_inline(parsed_nested), :link => :urls, :html => { :target => "_blank" },
        :sanitize => false)
      if options[:smilies]
        text = smilize(text)
      end
      text.html_safe
    end
  end
end
