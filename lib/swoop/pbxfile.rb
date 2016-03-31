require 'xcodeproj'

class Xcodeproj::Project::Object::PBXFileReference

  def swift?
    File.extname(real_path) == ".swift" && !category?
  end

  def objc?
    File.extname(real_path) == ".m" && !category?
  end

  def category?
    File.basename(real_path).include? "+"
  end
end
