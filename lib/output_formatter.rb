class OutputFormatter
  attr_accessor :file, :path, :ext

  def initialize(file, path:nil, ext:nil)
    @file = file
    @path = path
    @ext = ext
  end

  def to_s
    file_name = if ext
      File.basename(file, File.extname(file)) + ".#{ext}"
    else
      File.basename(file)
    end

    if path
      if File.directory?(path)
        File.join(path, file_name)
      else
        path
      end
    else
      file_name
    end
  end
end