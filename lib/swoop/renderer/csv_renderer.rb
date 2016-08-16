require 'digest'

module Swoop

  class CSVRenderer < Renderer

    def render
      File.write(filename, csv)
      puts "CSV file successfully created at '#{filename}'" if File.file?(filename)
    end

    private

    def filename
      @filename ||= begin
        reports_name = reports.map { |r| "#{r.name}-#{r.date.to_s}" }.to_s
        sha = Digest::SHA1.hexdigest(reports_name)
        "#{sha}.csv"
      end
    end

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
  end

end
