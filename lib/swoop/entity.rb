module Swoop

  # name : String
  # type : protocol, extension/category, class, struct
  # lang : swift, objc

  class Entity
    attr_reader :name, :language, :type

    def initialize(name, language, type)
      @name = name
      @language = language
      @type = type
    end

    def self.new_from_json(json)
      name = json['key.name']

      kind = json['key.kind']
      language = kind.split('.')[2]
      type = kind.split('.').last

      self.new(name, language, type)
    end

    def swift?
      language == "swift"
    end

    def objc?
      language == "objc"
    end

    def to_s
      "#{language} - #{name} : #{type}"
    end

    def ==(other)
      name == other.name && language == other.language && type == other.type
    end
  end

end
