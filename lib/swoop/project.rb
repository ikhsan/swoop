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

      raise "Error: Can't find directory :(" if project_dir.nil?

      files = project_dir
        .recursive_children
        .select { |f| valid_file? f }
        .map(&:real_path)

      raise "Error: No files are found :(" if files.empty?

      files
    end

    private

    def valid_file_extensions
      [".swift", ".h", ".m"]
    end

    def valid_file? (f)
      return false unless f.is_a?(Xcodeproj::Project::Object::PBXFileReference)

      ext = File.extname(f.real_path)
      valid_file_extensions.include?(ext)
    end

  end

end
