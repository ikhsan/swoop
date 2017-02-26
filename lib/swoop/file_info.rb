module Swoop

  module Lang
    NONE = 0
    OBJC = 1
    SWIFT = 2
  end

  class FileInfo

    attr_reader :filepath, :line_count, :classes, :structs, :extensions

    def initialize(filepath, line_count, classes, structs, extensions)
      @filepath = filepath
      @line_count = line_count
      @classes = classes
      @structs = structs
      @extensions = extensions
    end

    def language
      @language ||= begin
        return Lang::SWIFT if !entities.empty? && entities.first.swift?
        return Lang::OBJC if !entities.empty? && entities.first.objc?
        Lang::NONE
      end
    end

    def swift?
      language == Lang::SWIFT
    end

    def objc?
      language == Lang::OBJC
    end

    def entities
      @entities ||= begin
        [ *classes, *structs, *extensions ]
      end
    end

    def hash
      filepath.hash
    end

    def eql?(comparee)
      self == comparee
    end

    def ==(comparee)
      self.filepath == comparee.filepath
    end

  end

end
