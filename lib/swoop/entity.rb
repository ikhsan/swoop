module Swoop

  # name : String
  # type : protocol, extension/category, class, struct
  # lang : swift, objc

  class Entity
    attr_reader :name, :language, :type

    def initialize(json)
      @json = json
    end

    def name
      @name ||= @json['key.name']
    end

    def language
      @language ||= kind.split('.')[2]
    end

    def type
      @type ||= kind.split('.').last
    end

    def swift?
      language == "swift"
    end

    def to_s
      "#{language} - #{name} : #{type}"
    end

    def ==(other)
      name == other.name && language == other.language && type == other.type
    end

    private

    def kind
      @kind ||= @json['key.kind']
    end
  end

end
