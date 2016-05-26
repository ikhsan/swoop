module Swoop

  class Report

    def initialize(entities)
      @entities = entities

      # @objc = hash[:objc]
      # @swift = hash[:swift]
      #
      # @total =  @objc + @swift
      # @objc_p = @objc * 100.0 / @total
      # @swift_p = @swift * 100.0 / @total
    end

    def swift_classes_count
      swift_classes.count
    end

    def swift_structs_count
      swift_structs.count
    end

    def objc_classes_count
      0
    end

    def to_s
      "hello!"
      # "objc : #{objc} (#{'%.02f' % objc_p}%) swift : #{swift} (#{'%.02f' % swift_p}%) total : #{total}"
    end

    private

    def swift_classes
      @swift_classes ||= swift_entities.select(&:class?)
    end

    def swift_structs
      @swift_structs ||= swift_entities.select(&:struct?)
    end

    def swift_entities
      @swift_entities ||= @entities.select(&:swift?)
    end

    def objc_entities
      @objc_entities ||= @entities.select(&:objc?)
    end

  end

end
