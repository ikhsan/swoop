module Swoop

  class Report

    attr_reader :objc, :swift, :total, :objc_p, :swift_p

    def initialize(hash)
      @objc = hash[:objc]
      @swift = hash[:swift]

      @total =  @objc + @swift
      @objc_p = ((@objc * 100.0) / @total).round(2)
      @swift_p = ((@swift * 100.0) / @total).round(2)
    end

    def to_s
      "objc : #{objc} (#{objc_p}%) swift : #{swift} (#{swift_p}%) total : #{total}"
    end

  end

end
