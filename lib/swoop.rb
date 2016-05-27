require "swoop/version"
require "swoop/project"
require "swoop/entity"
require "swoop/entity_parser"
require "swoop/report"
require "swoop/helper"
require "swoop/sourcekitten"

require "thor"
require 'xcodeproj'
require 'git'
require 'Logger'

module Swoop

  class Reporter < Thor
    include Helper

    # /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj
    # bundle exec bin/swoop report --path /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj --folder 'Classes/Models'
    # bundle exec bin/swoop report --path spec/fixture/Swoop/Swoop.xcodeproj --folder 'Swoop/Model'

    desc "report", "Create objc swift comparison report for classes from an Xcode project"
    option :path
    option :folder
    def report
      project_path = options[:path]
      folder = options[:folder]

      summarise_report(project_path, folder)
    end

    private

    def create_report(project_path, dir_path)
      project = Project.new(project_path, dir_path)
      entities = project.filepaths.map { |p| EntityParser.new(p).entities }.flatten
      report = Report.new(entities)
      report
    end

    def summarise_report(project_path, dir_path)
      working_dir = get_git_root(project_path)
      g = Git.open(working_dir)

      tags = g.tags
        .sort { |a, b| a.log.first.date <=> b.log.first.date }
        .select { |e| e.name.match('^v\d+.\d+') }
        .last(15)

      summary = tags.map { |t|
        log = t.log.first

        g.checkout(log.sha)

        name = t.name
        date = log.date.strftime("%d-%m-%Y")
        report = create_report(project_path, dir_path)

        { :name => name, :date => date, :report => report }
      }

      g.branches[:master].checkout

      puts "\nSwift Swoop Report  : '#{dir_path}'"

      summary.each { |s|
        puts "#{s[:name]} - #{s[:date]}\n"
        puts "==="
        puts s[:report]
        puts "\n\n"
      }

    end

    # def summarise_report(project_path, folder)
    #   working_dir = get_git_root project_path
    #   g = Git.open(working_dir)
    #
    #   full_report = g.tags
    #   .select { |t| t.name.include?("v5") }
    #   .map { |t|
    #
    #     log = t.log.first
    #     g.checkout(log.sha)
    #
    #     date = log.date.strftime("%d-%m-%Y")
    #     report = create_report(project_path, folder)
    #
    #     "#{report} || #{date} (#{t.name})"
    #   }
    #
    #   g.branches[:master].checkout
    #
    #   report = create_report(project_path, folder)
    #   date = Time.now.strftime("%d-%m-%Y")
    #   full_report << "#{report} || #{date} (HEAD)"
    #
    #   puts "\nSwift Swoop Report  : '#{folder}'"
    #   puts "=="
    #   puts full_report
    #   puts "\n"
    #
    #   return 1
    # end

  end

end
