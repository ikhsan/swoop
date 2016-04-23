require 'xcodeproj'

module Swoop

  class Project

    attr_reader :path, :directory

    def initialize(path, directory = 'Classes')
      @path = path
      @directory = directory
    end

    def files
      raise "Error: Project path is empty :(" if @path.empty?
      raise "Error: Can't find .xcodeproj project :(" unless File.exist? @path
      raise "Error: Invalid .xcodeproj file :(" unless File.extname(@path) == '.xcodeproj'

      project = Xcodeproj::Project.open @path

      project[directory].recursive_children
        .select { |f|
          is_a_file = f.is_a? Xcodeproj::Project::Object::PBXFileReference
          swift = File.extname(f.real_path) == '.swift'
          objc = File.extname(f.real_path) == '.m'
          is_a_file && (swift || objc)
        }
        .map(&:display_name)
    end

  end

end
