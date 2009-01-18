module FileProcessing
  require 'tempfile'
  
  def tempfile original_filename = 'file'    
    tempfile = Tempfile.new(original_filename)
    File.open(tempfile.path, 'wb') do |f|
      f.write(raw_data)
    end
    tempfile
  end
end