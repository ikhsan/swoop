require 'json'

module Swoop

  class EntityParser

    attr_reader :entities

    def self.parse_files(filepaths)
      filepaths
        .map { |p| self.new(p).entities }
        .flatten
        .uniq
    end

    def initialize(filepath)
      @filepath = filepath
    end

    def entities
      @entitites ||= begin
        return parse_swift if File.extname(@filepath) == ".swift"
        return parse_objc if File.extname(@filepath) == ".h"
        []
      end
    end

    private

    LANG_SWIFT = 'swift'
    LANG_OBJC = 'objc'
    TYPE_CLASS = 'class'
    TYPE_STRUCT = 'struct'
    TYPE_EXTENSION = 'extension'
    TYPE_CATEGORY = 'category'

    SWIFT_CLASS = /class\s*(\w+)/
    SWIFT_STRUCT = /struct\s*(\w+)/
    SWIFT_EXT = /extension\s*(\w+)/
    def parse_swift
      classes = file_content.scan(SWIFT_CLASS).flatten.map { |e| Entity.new(e, LANG_SWIFT, TYPE_CLASS) }
      structs = file_content.scan(SWIFT_STRUCT).flatten.map { |e| Entity.new(e, LANG_SWIFT, TYPE_STRUCT) }
      extensions = file_content.scan(SWIFT_EXT).flatten.map { |e| Entity.new(e, LANG_SWIFT, TYPE_EXTENSION) }

      [ *classes, *structs, *extensions ]
    end

    OBJC_CLASS = /@interface\s*(\w+)\s*:/
    OBJC_CATEGORY = /@interface\s*(\w+)\s*\((.*)\)/
    OBJC_STRUCT = /typedef\s*struct\s*{.*?}\s*(\w*)/m
    OBJC_STRUCT2 = /struct\s*(\w+)/
    def parse_objc
      classes = file_content.scan(OBJC_CLASS).flatten.map { |e| Entity.new(e, LANG_OBJC, TYPE_CLASS) }
      categories = file_content.scan(OBJC_CATEGORY)
        .map { |exts|
          exts.select { |e| !e.empty? }.join('+')
        }
        .map { |e| Entity.new(e, LANG_OBJC, (e.include?('+') ? TYPE_CATEGORY : TYPE_EXTENSION)) }
      structs = (file_content.scan(OBJC_STRUCT) + file_content.scan(OBJC_STRUCT2)).flatten
        .map { |e| Entity.new(e, LANG_OBJC, TYPE_STRUCT) }

      [ *classes, *structs, *categories ]
    end

    def file_content
      @file_content ||= File.read(@filepath)
    end
  end

end
