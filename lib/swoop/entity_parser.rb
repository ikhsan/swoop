module Swoop

  class EntityParser

    attr_reader :entities

    def initialize(path)
      @path = path
    end

    def entities
      @entitites ||= begin
        json_objects = SourceKitten.run(@path)
        json_objects.map { |json| Entity.new_from_json(json) }.flatten
      end
    end

  end

end
