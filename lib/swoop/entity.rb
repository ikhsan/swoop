module Swoop

  class Entity
    attr_reader :name, :language, :type

    def initialize(name, language, type)
      @name = name
      @language = language
      @type = type
    end

    def self.new_from_json(json)
      name = json['key.name']

      kind = json['key.kind'].split('.')
      kind.shift if kind.first == 'sourcekitten'
      language = kind[2]
      type = kind.last

      self.new(name, language, type)
    end

    def swift?
      language == "swift"
    end

    def objc?
      language == "objc"
    end

    def class?
      type == "class"
    end

    def struct?
      type == "struct"
    end

    def extension?
      type == "extension" || type == "category"
    end

    def to_s
      "#{language} - #{name} : #{type}"
    end

    def ==(other)
      name == other.name && language == other.language && type == other.type
    end
  end

end
