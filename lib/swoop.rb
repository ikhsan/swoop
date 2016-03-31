require "swoop/version"
require "swoop/pbxfile"
require "swoop/report"

require "thor"
require 'xcodeproj'
require 'git'
require 'Logger'

module Swoop

  class Reporter < Thor

    # /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj
    # Models
    # bundle exec bin/swoop report --path /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj --folder Models

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

      folder = options[:folder] || 'Classes'

      working_dir = get_git_root project_path
      # g = Git.open(working_dir, :log => Logger.new(STDOUT))
      g = Git.open(working_dir)

      full_report = g.tags
      .select { |t| t.name.include?("v5") }
      .map { |t|

        log = t.log.first
        g.checkout(log.sha)

        date = log.date.strftime("%d-%m-%Y")
        report = create_report(project_path, folder)

        "#{date} (#{t.name}) || #{report}"
      }

      puts "\n\n'#{folder}' Swoop Report"
      puts "=="
      puts full_report
      puts "\n"

      return 1

    end

    private

    def get_git_root(project_path)
      current_dir = `pwd`
      project_dir = File.dirname project_path

      path = `cd #{project_dir};git rev-parse --show-toplevel;cd #{current_dir}`
      return path.strip
    end

    def create_report(project_path, folder_to_report)

      project = Xcodeproj::Project.open(project_path)

      # Get the files from folder
      folder = project.objects
        .select { |o| o.display_name == folder_to_report }
        .first
      if folder.nil?
        puts "Error: no files in folder `#{folder_to_report}` were found :("
        return
      end

      files = folder
        .recursive_children
        .select { |o| o.is_a?(Xcodeproj::Project::Object::PBXFileReference) }

      report = files.reduce({ :objc => 0, :swift => 0 }) { |memo, f|
        memo[:objc] += 1 if f.objc?
        memo[:swift] += 1 if f.swift?
        memo
      }

      r = Report.new(report)
      r
    end

  end

end
