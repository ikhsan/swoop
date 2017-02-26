module Swoop

  class Report

    attr_reader :name

    def initialize(file_infos, name = '', date = Time.now)
      @file_infos = file_infos
      @date = date

      if name.nil? || name == ''
        @name = date.strftime("%d-%m-%Y")
      else
        @name = name
      end
    end

    def date
      @date.strftime("%d-%m-%Y")
    end

    # Classes
    def classes_count
      classes.count
    end

    def swift_classes_count
      swift_classes.count
    end

    def objc_classes_count
      objc_classes.count
    end

    def swift_classes_percentage
      return 0 if classes_count == 0
      (swift_classes_count.to_f / classes_count) * 100
    end

    def objc_classes_percentage
      return 0 if classes_count == 0
      (objc_classes_count.to_f / classes_count) * 100
    end

    # Structs

    def structs_count
      structs.count
    end

    def swift_structs_count
      swift_structs.count
    end

    def objc_structs_count
      objc_structs.count
    end

    def swift_structs_percentage
      return 0 if structs_count == 0
      (swift_structs_count.to_f / structs_count) * 100
    end

    def objc_structs_percentage
      return 0 if structs_count == 0
      (objc_structs_count.to_f / structs_count) * 100
    end

    # Extensions

    def extensions_count
      extensions.count
    end

    def swift_extensions_count
      swift_extensions.count
    end

    def objc_extensions_count
      objc_extensions.count
    end

    def swift_extensions_percentage
      return 0 if extensions_count == 0
      (swift_extensions_count.to_f / extensions_count) * 100
    end

    def objc_extensions_percentage
      return 0 if extensions_count == 0
      (objc_extensions_count.to_f / extensions_count) * 100
    end

    def to_s
      "Class | swift : #{swift_classes_count} (#{'%.02f' % swift_classes_percentage}%) , objc : #{objc_classes_count} (#{'%.02f' % objc_classes_percentage}%), total: #{classes_count} \n" +
      "Structs | swift : #{swift_structs_count} (#{'%.02f' % swift_structs_percentage}%) , objc : #{objc_structs_count} (#{'%.02f' % objc_structs_percentage}%), total: #{structs_count} \n" +
      "Extensions | swift : #{swift_extensions_count} (#{'%.02f' % swift_extensions_percentage}%) , objc : #{objc_extensions_count} (#{'%.02f' % objc_extensions_percentage}%), total: #{extensions_count}"
    end

    private

    def classes
      @classes ||= @file_infos.flat_map(&:classes)
    end

    def structs
      @structs ||= @file_infos.flat_map(&:structs)
    end

    def extensions
      @extensions ||= @file_infos.flat_map(&:extensions).uniq
    end

    def swift_file_infos
      @swift_file_infos ||= @file_infos.select(&:swift?)
    end

    def swift_classes
      @swift_classes ||= swift_file_infos.flat_map(&:classes)
    end

    def swift_structs
      @swift_structs ||= swift_file_infos.flat_map(&:structs)
    end

    def swift_extensions
      @swift_extensions ||= swift_file_infos.flat_map(&:extensions).uniq
    end

    def objc_file_infos
      @objc_file_infos ||= @file_infos.select(&:objc?)
    end

    def objc_classes
      @objc_classes ||= objc_file_infos.flat_map(&:classes)
    end

    def objc_structs
      @objc_structs ||= objc_file_infos.flat_map(&:structs)
    end

    def objc_extensions
      @objc_extensions ||= objc_file_infos.flat_map(&:extensions).uniq
    end
  end
end
