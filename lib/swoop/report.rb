module Swoop

  class Report

    attr_reader :entities

    def initialize(entities)
      @entities = entities

      # @objc = hash[:objc]
      # @swift = hash[:swift]
      #
      # @total =  @objc + @swift
      # @objc_p = @objc * 100.0 / @total
      # @swift_p = @swift * 100.0 / @total
    end

    def to_s
      "hello!"
      # "objc : #{objc} (#{'%.02f' % objc_p}%) swift : #{swift} (#{'%.02f' % swift_p}%) total : #{total}"
    end

  end

end
