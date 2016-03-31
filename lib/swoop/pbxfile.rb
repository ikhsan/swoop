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

  def swift_count
    return 1 if swift?
    return 0
  end

  def objc_count
    return 1 if objc?
    return 0
  end


end
