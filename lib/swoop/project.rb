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
      project_dir = project[directory]

      raise "Error: No files are found :(" if project_dir.nil?

      files = project_dir.recursive_children
        .select { |f| swift_file?(f) || objc_file?(f) }
        .map(&:real_path)

      raise "Error: No files are found :(" if files.empty?

      files
    end

    private

    def file?(f)
      f.is_a?(Xcodeproj::Project::Object::PBXFileReference)
    end

    def swift_file?(f)
      file?(f) && File.extname(f.real_path) == '.swift'
    end

    def objc_file?(f)
      file?(f) && (File.extname(f.real_path) == '.m' || File.extname(f.real_path) == '.h')
    end

  end

end
