class Members
  def initialize()
    @dataDir =  File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__)))) + "/data"
  end

  def getData()
    filename = "#{@dataDir}/members.json"
    if File.exist?(filename) then
      return File.read(filename, :encoding => Encoding::UTF_8)
    end

    return nil
  end
end
