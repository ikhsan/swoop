require 'json'
require 'pathname'
require 'shellwords'
require 'swoop/entity'

module Swoop
  class SourceKitten
    def self.run file_path
      bin_path = Pathname(__FILE__).parent + 'SourceKitten/bin/sourcekitten'
      output = `#{Shellwords.escape(bin_path)} structure --file #{file_path}`

      json_output = JSON.parse(output)
      substructures = json_output["key.substructure"]
      return [] if substructures.nil? || substructures.empty?
      substructures
    end
  end
end
