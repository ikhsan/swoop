require 'erb'

module Swoop

  class ChartRenderer < Renderer

    attr_reader :filename

    def initialize(reports, title, filename = "index.html")
      super(reports, title)
      @filename = filename
    end

    def class_count_data
      rows = []
      rows << ['Date', 'Swift Class', 'Objective-C Class']
      rows += reports.map { |r| [ "#{r.name}\n(#{r.date})", r.swift_classes_count, r.objc_classes_count]  }
      rows.to_s
    end

    def class_percentage_data
      rows = []
      rows << ['Date', 'Swift Class (%)', 'Objective-C Class (%)']
      rows += reports.map { |r| [ "#{r.name}\n(#{r.date})", r.swift_classes_percentage, r.objc_classes_percentage]  }
      rows.to_s
    end

    def render
      empty_target_dir
      copy_assets
      html_path = render_html
      `open #{html_path}`
    end

    private

    def source_dir
      @source_dir ||= File.expand_path("./lib/swoop/renderer/chart_renderer")
    end

    def target_dir
      @target_dir ||= File.expand_path("./html")
    end

    def empty_target_dir
      FileUtils.rm_rf(target_dir) if Dir.exist?(target_dir)
      FileUtils.mkdir_p(target_dir)
    end

    def copy_assets
      FileUtils.cp(File.join(source_dir, "styles.css"), target_dir)
    end

    def render_html
      template_path = File.join(source_dir, "chart.html.erb")
      template = ERB.new(File.read(template_path))
      html_content = template.result(binding)

      html_path = File.join(target_dir, filename)
      File.open(html_path, "w") do |file|
        file.puts html_content
      end

      html_path
    end
  end

end
