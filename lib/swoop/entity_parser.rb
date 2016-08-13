require 'json'

module Swoop

  class EntityParser

    attr_reader :entities

    def self.parse_files(filepaths)
      filepaths.map { |path| self.new(path).entities }.flatten
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

    def file_content
      @file_content ||= File.read(@filepath)
    end

    SWIFT_CLASS = /class\s*(\w+)/
    SWIFT_STRUCT = /struct\s*(\w+)/
    SWIFT_EXT = /extension\s*(\w+)/
    def parse_swift
      classes = file_content.scan(SWIFT_CLASS).flatten.map { |e| Entity.new(e, 'swift', 'class') }
      structs = file_content.scan(SWIFT_STRUCT).flatten.map { |e| Entity.new(e, 'swift', 'struct') }
      extensions = file_content.scan(SWIFT_EXT).flatten.map { |e| Entity.new(e, 'swift', 'extension') }

      [ *classes, *structs, *extensions ]
    end

    OBJC_CLASS = /@interface\s*(\w+)\s*:/
    OBJC_CATEGORY = /@interface\s*(\w+)\s*\((.*)\)/
    def parse_objc
      classes = file_content.scan(OBJC_CLASS).flatten.map { |e| Entity.new(e, 'objc', 'class') }
      categories = file_content.scan(OBJC_CATEGORY)
        .map { |exts|
          exts
            .select { |e| !e.empty? }
            .join('+')
        }
        .map { |e| Entity.new(e, 'objc', (e.include?('+') ? 'category' : 'extension')) }

      [ *classes, *categories ]
    end

  end

end
