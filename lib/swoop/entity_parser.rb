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
        []
      end
    end

    private

    SWIFT_CLASS = /class\s*(\w+)/
    SWIFT_STRUCT = /struct\s*(\w+)/
    SWIFT_EXT = /extension\s*(\w+)/
    def parse_swift
      contents = File.read(@filepath)

      classes = contents.scan(SWIFT_CLASS).flatten.map { |c| Entity.new(c, 'swift', 'class') }
      structs = contents.scan(SWIFT_STRUCT).flatten.map { |s| Entity.new(s, 'swift', 'struct') }
      extensions = contents.scan(SWIFT_EXT).flatten.map { |e| Entity.new(e, 'swift', 'extension') }

      [ *classes, *structs, *extensions ]
    end

  end

end
