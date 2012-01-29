class Icon
  def self.all
    icons = Dir.entries(USER_ICONS_PATH)
    icons.reject { |icon| icon =~ /^\.\.?$/ }
  end
end
