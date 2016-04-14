require 'xcodeproj'
require 'swoop/sourcekitten'

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
    if swift?
      Swoop::SourceKitten.run real_path
      1
    end
    0
  end

  def objc_count
    if objc?
      Swoop::SourceKitten.run real_path
      1
    end
    0
  end

end
