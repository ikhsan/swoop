require 'json'
require 'pathname'

module Swoop

  class SourceKitten

    # name : String
    # type : protocol, extension/category, class, struct
    # lang : swift, objc

    # Run sourcekitten with given arguments and return STDOUT
    # Swoop::SourceKitten.run real_path

    def self.run file_path
      output = `#{bin_path} structure --file #{file_path}`
      extract(output)
    end

    private

    def self.bin_path
      Pathname(__FILE__).parent + 'SourceKitten/bin/sourcekitten'
    end

    def self.extract(output)
      json_output = JSON.parse(output)
      substructures = json_output["key.substructure"]

      substructures.map { |s| self.parse s }
    end

    def self.parse(substructure)
      kind = substructure['key.kind']
      type = kind.split('.').last
      lang = kind.split('.')[2]

      {
        :name => substructure['key.name'],
        :lang => lang,
        :type => type
      }
    end

  end

end
