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
    # bundle exec bin/swoop --path ~/Songkick/ios-app/Songkick/Songkick.xcodeproj --dir 'Classes' --filter_tag '^v\d+.\d+'
    # bundle exec bin/swoop --path ~/Songkick/ios-app/Songkick/Songkick.xcodeproj --dir 'Classes' --filter_tag '^v\d+.\d+' --tags 12

    desc "report", "Create comparison report from Swift and Objective-C files inside your Xcode project"
    long_desc <<-LONGDESC
      `swoop` will make Swift and Objective-C comparison report out of your files inside an Xcode project.

      It requires two required options, `path` for specifying your Xcode project's path and `dir` to specify Xcode directory from your project.

      > $ swoop --path ~/YourAwesomeProject/AwesomeProject.xcodeproj --dir 'Classes/Network'

      There are three supported renderer that can be choosen using `renderer` option; `table` (default), `csv` and `chart`.

      > $ swoop --path ~/YourAwesomeProject/AwesomeProject.xcodeproj --dir 'Classes' --render chart
    LONGDESC
    option :path, :required => true, :desc => "Specify your .xcodeproj path"
    option :dir, :required => true, :desc => "Specify your folder from your Xcode project"
    option :tags, :desc => "Specify how many tags to include (if not specified then it defaults to 8 latest tags)"
    option :filter_tag, :desc => "Regular expression for filtering tags format"
    option :weeks, :desc => "Specify how many weeks to include"
    option :render, :desc => "Choose your renderer, if not specified will default to `table`", :banner => "['table', 'csv', 'chart']"
    def report
      @project_path = options[:path]
      @dir_path = options[:dir]
      @renderer_type = options[:render]

      @filter_tag = options[:filter_tag]
      @tags = options[:tags]
      @weeks = options[:weeks]

      renderer = renderer_class.new(summary_report, title)
      renderer.render
    end

    default_task :report

    private

    def summary_report
      @summary_report ||= begin
        reports = []

        project = Project.new(@project_path, @dir_path)
        delorean = TimeMachine.new(project, time_machine_options)
        delorean.travel do |proj, name, date|
          entities = EntityParser.parse_files(proj.filepaths)
          reports << Report.new(entities, name, date)
        end

        reports
      end
    end


    def time_machine_options
      options = {}
      options[:tags] = @tags.to_i unless @tags.nil? || @tags.empty?
      options[:filter] = @filter_tag unless @filter_tag.nil? || @filter_tag.empty?
      options[:weeks] = @weeks.to_i unless @weeks.nil? || @weeks.empty?
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
