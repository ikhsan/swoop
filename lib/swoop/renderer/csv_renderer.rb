module Swoop

  class CSVRenderer < Renderer

    attr_reader :filename

    def initialize(reports, title, filename = nil)
      super(reports, title)
      @filename = filename
    end

    def render
     @filename.nil? ? render_to_console : render_to_file
    end

    private

    def csv
      @csv ||= begin
        lines = []
        lines << "name,date,swift class,swift class %,objc class,objc class %,total class,swift struct,swift struct %,objc struct,objc struct %,total struct,swift extension,swift extension %,objc extension,objc extension %,total extension"

        reports.each do |report|
          lines << "#{report.name},#{report.date},#{report.swift_classes_count},#{'%.02f' % report.swift_classes_percentage},#{report.objc_classes_count},#{'%.02f' % report.objc_classes_percentage},#{report.classes_count},#{report.swift_structs_count},#{'%.02f' % report.swift_structs_percentage},#{report.objc_structs_count},#{'%.02f' % report.objc_structs_percentage},#{report.structs_count},#{report.swift_extensions_count},#{'%.02f' % report.swift_extensions_percentage},#{report.objc_extensions_count},#{'%.02f' % report.objc_extensions_percentage},#{report.extensions_count}"
        end

        lines.join("\n")
      end
    end

    def render_to_console
      puts csv
    end

    def render_to_file
      path = "#{filename}.csv"
      File.write(path, csv)
      "CSV file successfully created at '#{path}'" if File.file?(path)
    end
  end

end
