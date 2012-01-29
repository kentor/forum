class Smiley < ActiveRecord::Base
  validates :filename, :presence => true, :length => { :maximum => 50 }
  validates :code, :presence => true, :uniqueness => true, :length => { :maximum => 20 }
  
  def self.store(image_file, code)
    filename = image_file.original_filename
    file = File.new("#{SMILIES_PATH}/#{filename}", "wb")
    file.write(image_file.read)
    file.close
    smiley = self.new(:filename => filename, :code => code)
    smiley.save
  end
  
  def remove
    file = "#{SMILIES_PATH}/#{filename}"
    File.delete(file) if File.exists?(file)
    self.destroy
  end
end
