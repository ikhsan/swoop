require 'terminal-table'

module Swoop

  class TableRenderer < Renderer

    def render
      puts table
    end

    private

    def table
      headings =  ["name", "date", "swift\nclass", "swift\nclass (%)", "objc\nclass", "objc\nclass (%)", "total\nclass", "swift\nstruct", "swift\nstruct(%)", "objc\nstruct", "objc\nstruct(%)", "total\nstruct", "swift\next", "swift\next(%)", "objc\next", "objc\next(%)", "total\next"]
      rows = reports.map do |r|
        [r.name,r.date,r.swift_classes_count,"#{'%.02f' % r.swift_classes_percentage}",r.objc_classes_count,"#{'%.02f' % r.objc_classes_percentage}",r.classes_count,r.swift_structs_count,"#{'%.02f' % r.swift_structs_percentage}",r.objc_structs_count,"#{'%.02f' % r.objc_structs_percentage}",r.structs_count,r.swift_extensions_count,"#{'%.02f' % r.swift_extensions_percentage}",r.objc_extensions_count,"#{'%.02f' % r.objc_extensions_percentage}",r.extensions_count]
      end

      @table ||= Terminal::Table.new(:title => title, :headings => headings, :rows => rows)
    end

  end

end
