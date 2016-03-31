require "swoop/version"
require "thor"
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

module Swoop

  class Reporter < Thor

    # /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj
    # Models

    desc "report", "Create objc swift comparison report for classes from an Xcode project"
    option :path
    option :folder
    def report
      if options[:path].nil?
        puts "Error: missing xcodeproj path :("
        return
      end

      project_path = options[:path]

      if !File.exist? project_path
        puts "Error: missing project path :("
        return
      end

      project = Xcodeproj::Project.open(project_path)
      folder_to_report = options[:folder] || 'Classes'

      # Get the files from folder
      files = project.objects
        .select { |o| o.display_name == folder_to_report }
        .first

      if files.nil?
        puts "Error: no files in folder `#{folder_to_report}` were found :("
        return
      end

      files_children = files
        .recursive_children
        .select { |o| o.is_a?(Xcodeproj::Project::Object::PBXFileReference) }

      report = files.reduce({ :objc => 0, :swift => 0 }) { |memo, f|
        memo[:objc] += 1 if f.objc?
        memo[:swift] += 1 if f.swift?
        memo
      }

      # Make the report
      report[:total] = report.values.reduce(&:+)
      report[:objc_p] = ((report[:objc] * 100.0) / report[:total]).round(2)
      report[:swift_p] = ((report[:swift] * 100.0) / report[:total]).round(2)

      puts "#{folder_to_report} \nobjc : #{report[:objc]} (#{report[:objc_p]}%)\nswift : #{report[:swift]} (#{report[:swift_p]}%) \ntotal : #{report[:total]}"

      return
    end
  end

end
