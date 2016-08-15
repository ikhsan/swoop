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
    # bundle exec bin/swoop --path /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj --dir 'Classes/Models'

    desc "report", "Create objc swift comparison report for classes from an Xcode project"
    option :path
    option :dir
    option :renderer
    def report
      @project_path = options[:path]
      @dir_path = options[:dir]
      @renderer_type = options[:renderer]

      renderer = renderer_class.new(summary_report, title)
      renderer.render
    end

    default_task :report

    private

    def summary_report
      @summary_report ||= begin
        project = Project.new(@project_path, @dir_path)
        delorean = TimeMachine.new(project) # { :weeks => 10 }

        reports = []
        delorean.travel do |proj, name, date|
          entities = EntityParser.parse_files(proj.filepaths)
          reports << Report.new(entities, name, date)
        end
        reports
      rescue Exception => e
        raise e
      end
    end

    def title
      "Swoop Report : '#{@dir_path}'"
    end

    def renderer_class
      case @renderer_type
      when "csv"
        CSVRenderer
      when "chart"
        ChartRenderer
      else
        TableRenderer
      end
    end
  end

end
