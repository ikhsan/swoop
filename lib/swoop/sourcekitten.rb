require 'json'
require 'pathname'

module Swoop

  class SourceKitten

    # Run sourcekitten with given arguments and return STDOUT
    def self.run file_path
      bin_path = Pathname(__FILE__).parent + 'SourceKitten/bin/sourcekitten'

      output = `#{bin_path} structure --file #{file_path}`

      json_output = JSON.parse(output)

      substructure = json_output["key.substructure"]

      unless substructure.nil?
        output = substructure.map { |s| s['key.kind'] }
      end

      # puts "#{File.basename(file_path)} - #{subsctructure.count}" unless subsctructure.nil?
      puts output
    end

  end

end
