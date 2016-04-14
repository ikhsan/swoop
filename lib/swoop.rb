require "swoop/version"
require "swoop/pbxfile"
require "swoop/report"
require "swoop/helper"

require "thor"
require 'xcodeproj'
require 'git'
require 'Logger'

module Swoop

  class Reporter < Thor
    include Helper

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
        return 0
      end

      folder = options[:folder] || 'Classes'

      summarise_report2 project_path, folder
    end

    private

    def summarise_report2(project_path, folder)
      report = create_report(project_path, folder)
      puts report
    end

    def summarise_report(project_path, folder)
      working_dir = get_git_root project_path
      g = Git.open(working_dir)

      full_report = g.tags
      .select { |t| t.name.include?("v5") }
      .map { |t|

        log = t.log.first
        g.checkout(log.sha)

        date = log.date.strftime("%d-%m-%Y")
        report = create_report(project_path, folder)

        "#{report} || #{date} (#{t.name})"
      }

      g.branches[:master].checkout

      report = create_report(project_path, folder)
      date = Time.now.strftime("%d-%m-%Y")
      full_report << "#{report} || #{date} (HEAD)"

      puts "\nSwift Swoop Report  : '#{folder}'"
      puts "=="
      puts full_report
      puts "\n"

      return 1
    end

    def create_report(project_path, folder_to_report)

      project = Xcodeproj::Project.open(project_path)

      # Get the files from folder
      folder = project.objects
        .select { |o| o.display_name == folder_to_report }
        .first

      if folder.nil?
        puts "Error: no files in folder `#{folder_to_report}` were found :("
        return 0
      end

      files = folder
        .recursive_children
        .select { |o| o.is_a?(Xcodeproj::Project::Object::PBXFileReference) }

      report = files.reduce({ :objc => 0, :swift => 0 }) { |memo, f|
        memo[:objc] += f.objc_count
        memo[:swift] += f.swift_count
        memo
      }

      r = Report.new(report)
      r
    end

  end

end
