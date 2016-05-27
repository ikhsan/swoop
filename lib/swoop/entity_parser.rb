module Swoop

  class EntityParser

    attr_reader :entities

    def initialize(path)
      @path = path
    end

    def entities
      @entitites ||= parsed_entities
    end

    private

    def parsed_entities
      return swift_entities if path_to_swift?(@path)
      return objc_entities if path_to_objc?(@path)
      []
    end

    def path_to_swift?(path)
      File.extname(path) == ".swift"
    end

    def path_to_objc?(path)
      File.extname(path) == ".h"
    end

    def swift_entities
      json_objects = SourceKitten.run(@path)
      json_objects.map { |json| Entity.new_from_json(json) }.flatten
    end

    def objc_entities
      filename = File.basename(@path)
      type = filename.include?("+") ? "category" : "class"
      entity = Entity.new(filename, "objc", type)

      [ entity ]
    end

  end

end
