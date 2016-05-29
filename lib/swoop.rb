require "swoop/version"
require "swoop/project"
require "swoop/entity"
require "swoop/entity_parser"
require "swoop/report"
require "swoop/sourcekitten"
require "swoop/time_machine"

require "thor"

module Swoop

  class Reporter < Thor
    # /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj
    # bundle exec bin/swoop --path /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj --folder 'Classes/Models'
    # bundle exec bin/swoop --path spec/fixture/Swoop/Swoop.xcodeproj --folder 'Swoop/Model'

    desc "report", "Create objc swift comparison report for classes from an Xcode project"
    option :path
    option :folder
    def report
      project_path = options[:path]
      folder = options[:folder]

      summarise_report(project_path, folder)
    end

    default_task :report

    private

    def create_report(project_path, dir_path, name, date)
      project = Project.new(project_path, dir_path)
      entities = project.filepaths.map { |p| EntityParser.new(p).entities }.flatten
      return Report.new(entities, name, date)
    end

    def summarise_report(project_path, dir_path)
      reports = []

      delorean = TimeMachine.new(project_path, { :tags => 15 })
      delorean.travel { |name, date| reports << create_report(project_path, dir_path, name, date) }

      # renderer = TableRenderer.new(summary)
      # renderer.render
      puts "\nSwift Swoop Report  : '#{dir_path}'"
      puts reports
    end
  end

end
