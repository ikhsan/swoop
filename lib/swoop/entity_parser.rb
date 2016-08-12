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

        # output = SourceKitten.run(@path)
        # json_objects = parse(output)
        # json_objects.map { |json| Entity.new_from_json(json) }.flatten
      end
    end

    private

    SWIFT_CLASS = /class\s*(\w+)/
    def parse_swift
      contents = File.read(@filepath)
      classnames = contents.scan(SWIFT_CLASS).flatten
      classes = classnames.map { |c| Entity.new(c, 'swift', 'class') }
      [ *classes ]
    end

    # def parse_objc(output)
    #   json_output = JSON.parse(output)
    #   return [] if json_output.nil? || json_output.empty?
    #
    #   substructures = json_output.first.values.first['key.substructure']
    #   return [] if substructures.nil? || substructures.empty?
    #
    #   substructures
    # end

  end

end
