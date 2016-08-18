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
    # bundle exec bin/swoop --path ~/Songkick/ios-app/Songkick/Songkick.xcodeproj --dir 'Classes' --filter_tag '^v\d+.\d+

    desc "report", "Create comparison report from Swift and Objective-C files inside your Xcode project"
    long_desc <<-LONGDESC
      `swoop` will make Swift and Objective-C comparison report out of your files inside an Xcode project.

      It requires two required options, `path` for specifying your Xcode project's path and `dir` to specify Xcode directory from your project.

      > $ swoop --path ~/YourAwesomeProject/AwesomeProject.xcodeproj --dir 'Classes/Network'

      There are three supported renderer that can be choosen using `renderer` option; `table` (default), `csv` and `graph`.

      > $ swoop --path ~/YourAwesomeProject/AwesomeProject.xcodeproj --dir 'Classes' --renderer graph
    LONGDESC
    option :path, :required => true, :desc => "Specify your .xcodeproj path"
    option :dir, :required => true, :desc => "Specify your folder from your Xcode project"
    option :renderer, :desc => "Choose your renderer, if not specified will default to `table`", :banner => "['table', 'csv', 'graph']"
    option :filter_tag, :desc => "Regular expression for filtering tags format"
    def report
      @project_path = options[:path]
      @dir_path = options[:dir]
      @renderer_type = options[:renderer]

      @filter_tag = options[:filter_tag]


      renderer = renderer_class.new(summary_report, title)
      renderer.render
    end

    default_task :report

    private

    def summary_report
      @summary_report ||= begin
        project = Project.new(@project_path, @dir_path)
        delorean = TimeMachine.new(project, time_machine_options)

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

    def time_machine_options
      options = {}
      options[:filter] = @filter_tag unless @filter_tag.nil? || @filter_tag.empty?
      options
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
