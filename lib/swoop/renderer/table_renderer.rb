require 'terminal-table'

module Swoop

  class TableRenderer < Renderer

    def render
      puts table
    end

    private

    def f(lines)
      return lines if lines < 1_000

      count_in_thousand = Integer(Float(lines) / Float(1_000))
      "#{count_in_thousand}K"
    end

    def table
      headings =  [
        "name", "date",
        "swift\nfiles (%)", "objc\nfiles (%)",
        "swift\nlines (%)", "objc\nlines (%)",
        "swift\nclass (%)", "objc\nclass (%)",
        "swift\nstruct(%)", "objc\nstruct(%)",
        "swift\next(%)", "objc\next(%)"
      ]
      rows = reports.map do |r|
        [r.name,r.date,
          "#{'%.02f' % r.swift_files_percentage} (#{f r.swift_files_count}/#{f r.files_count})",
          "#{'%.02f' % r.objc_files_percentage} (#{f r.objc_files_count}/#{f r.files_count})",
          "#{'%.02f' % r.swift_lines_percentage} (#{f r.swift_lines_count}/#{f r.lines_count})",
          "#{'%.02f' % r.objc_lines_percentage} (#{f r.objc_lines_count}/#{f r.lines_count})",
          "#{'%.02f' % r.swift_classes_percentage} (#{r.swift_classes_count}/#{r.classes_count})",
          "#{'%.02f' % r.objc_classes_percentage} (#{r.objc_classes_count}/#{r.classes_count})",
          "#{'%.02f' % r.swift_structs_percentage} (#{r.swift_structs_count}/#{r.structs_count})",
          "#{'%.02f' % r.objc_structs_percentage} (#{r.objc_structs_count}/#{r.structs_count})",
          "#{'%.02f' % r.swift_extensions_percentage} (#{r.swift_extensions_count}/#{r.extensions_count})",
          "#{'%.02f' % r.objc_extensions_percentage} (#{r.objc_extensions_count}/#{r.extensions_count})",
        ]
      end

      @table ||= Terminal::Table.new(:title => title, :headings => headings, :rows => rows)
    end

  end

end
