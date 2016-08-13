require "swoop/version"
require "swoop/project"
require "swoop/entity"
require "swoop/entity_parser"
require "swoop/report"
require "swoop/time_machine"

require "swoop/renderer/renderer"
require "swoop/renderer/csv_renderer"
require "swoop/renderer/table_renderer"
require "swoop/renderer/chart_renderer"

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
      dir_path = options[:folder]
      # render_to = options[:render_to]
      # csv = options[:csv]

      reports = summarise_report(project_path, dir_path)
      title = "Swift Swoop Report : '#{dir_path}'"
      renderer(reports, title).render
    end

    default_task :report

    private

    def summarise_report(project_path, dir_path)
      project = Project.new(project_path, dir_path)
      delorean = TimeMachine.new(project, { :tags => 1 })

      reports = []
      delorean.travel do |proj, name, date|
        entities = EntityParser.parse_files(proj.filepaths)
        reports << Report.new(entities, name, date)
      end

      entities = get_entities(project.filepaths)
      reports << Report.new(entities, 'HEAD')

      reports
    end

    def renderer(reports, title, filename = nil)
      # CSVRenderer.new(reports, title, filename)
      # TableRenderer.new(reports, title)
      ChartRenderer.new(reports, title)
    end
  end

end
