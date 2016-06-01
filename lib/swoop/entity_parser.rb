require 'json'

module Swoop

  class EntityParser

    attr_reader :entities

    def initialize(path)
      @path = path
    end

    def entities
      @entitites ||= begin
        output = SourceKitten.run(@path)
        json_objects = parse(output)
        json_objects.map { |json| Entity.new_from_json(json) }.flatten
      end
    end

    private

    def parse(output)
      return [] if output.nil?
      return parse_objc(output) if File.extname(@path) == ".h"
      return parse_swift(output) if File.extname(@path) == ".swift"
      []
    end

    def parse_swift(output)
      json_output = JSON.parse(output)

      substructures = json_output.values.first['key.substructure']
      return [] if substructures.nil? || substructures.empty?

      substructures
    end

    def parse_objc(output)
      json_output = JSON.parse(output)
      return [] if json_output.nil? || json_output.empty?

      substructures = json_output.first.values.first['key.substructure']
      return [] if substructures.nil? || substructures.empty?

      substructures
    end

  end

end
