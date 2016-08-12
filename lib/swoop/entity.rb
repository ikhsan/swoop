module Swoop

  class Entity
    attr_reader :name, :language, :type

    def initialize(name, language, type)
      @name = name
      @language = language
      @type = type
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
