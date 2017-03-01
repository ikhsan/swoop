require 'json'

module Swoop

  class FileParser

    attr_reader :entityInfos

    def self.parse(filepaths)
      filepaths.map { |p| self.new(p).entityInfos }.compact.uniq
    end

    def initialize(filepath)
      @filepath = filepath
    end

    def entityInfos
      @entityInfos ||= begin
        return parse_swift if swift_file?
        return parse_objc if objc_header_file? || objc_implementation_file?
        nil
      end
    end

    private

    def swift_file?
      File.extname(@filepath) == ".swift"
    end

    def objc_header_file?
      File.extname(@filepath) == ".h"
    end

    def objc_implementation_file?
      File.extname(@filepath) == ".m"
    end

    def lines_count
      File.new(@filepath).readlines.size
    end

    LANG_SWIFT = 'swift'
    LANG_OBJC = 'objc'
    TYPE_CLASS = 'class'
    TYPE_STRUCT = 'struct'
    TYPE_EXTENSION = 'extension'
    TYPE_CATEGORY = 'category'

    SWIFT_CLASS = 'class\s*(\w+)'
    SWIFT_STRUCT = 'struct\s*(\w+)'
    SWIFT_EXT = 'extension\s*(\w+)'
    def parse_swift
      classes = filter(SWIFT_CLASS).map { |e| Entity.new(e, LANG_SWIFT, TYPE_CLASS) }
      structs = filter(SWIFT_STRUCT).map { |e| Entity.new(e, LANG_SWIFT, TYPE_STRUCT) }
      extensions = filter(SWIFT_EXT).map { |e| Entity.new(e, LANG_SWIFT, TYPE_EXTENSION) }

      FileInfo.new(@filepath, Lang::SWIFT, lines_count, classes, structs, extensions)
    end

    OBJC_CLASS = '@interface\s*(\w+)\s*:'
    OBJC_CATEGORY = '@interface\s*(\w+)\s*\((.*)\)'
    OBJC_STRUCT ='typedef\s*struct\s*{.*?}\s*(\w*)'
    OBJC_STRUCT2 = 'struct\s*(\w+)'
    def parse_objc
      # Only counting the lines and the file
      return FileInfo.new(@filepath, Lang::OBJC, lines_count, [], [], []) if objc_implementation_file?

      classes = filter(OBJC_CLASS).map { |e| Entity.new(e, LANG_OBJC, TYPE_CLASS) }
      categories = filter(OBJC_CATEGORY, false)
        .map { |exts|
          exts.select { |e| !e.empty? }.join('+')
        }
        .map { |e| Entity.new(e, LANG_OBJC, (e.include?('+') ? TYPE_CATEGORY : TYPE_EXTENSION)) }
      structs = (filter(OBJC_STRUCT, true, Regexp::MULTILINE) + filter(OBJC_STRUCT2))
        .map { |e| Entity.new(e, LANG_OBJC, TYPE_STRUCT) }

      FileInfo.new(@filepath, Lang::OBJC, lines_count, classes, structs, categories)
    end

    def file_content
      @file_content ||= File.read(@filepath)
    end

    def filter(expression, should_flatten = true, options = 0)
      # filter out comments
      regex = Regexp.new("#{expression}", options)
      contents = file_content.scan(regex)
      regex_comments = Regexp.new(".*\/\/.*#{expression}", options)
      commented = file_content.scan(regex_comments)

      filtered = contents - commented
      return filtered unless should_flatten
      filtered.flatten
    end

  end

end
