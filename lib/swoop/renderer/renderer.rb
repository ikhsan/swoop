module Swoop

  class Renderer
    attr_reader :reports, :title

    def initialize(reports, title)
      @reports = reports
      @title = title
    end

    def render
      # should be implemented by subclass
    end
  end

end
