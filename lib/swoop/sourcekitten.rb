require 'json'
require 'pathname'
require 'shellwords'
require 'swoop/entity'

module Swoop
  class SourceKitten
    def self.run(file_path)
      return parse_swift(file_path) if path_to_swift?(file_path)
      return parse_objc(file_path) if path_to_objc?(file_path)
      []
    end

    private

    def self.path_to_swift?(path)
      File.extname(path) == ".swift"
    end

    def self.path_to_objc?(path)
      File.extname(path) == ".h"
    end

    def self.parse_swift(file_path)
      output = `#{Shellwords.escape(bin_path)} doc --single-file '#{file_path}' -- -j4 '#{file_path}'`

      # puts output

      json_output = JSON.parse(output)
      substructures = json_output.values.first['key.substructure']
      return [] if substructures.nil? || substructures.empty?
      substructures
    end

    def self.parse_objc(file_path)
      output = `#{Shellwords.escape(bin_path)} doc --objc '#{file_path}' -- -x objective-c -isysroot $(xcrun --show-sdk-path) -I $(pwd)`

      json_output = JSON.parse(output)
      return [] if json_output.nil? || json_output.empty?
      substructures = json_output.first.values.first['key.substructure']
      return [] if substructures.nil? || substructures.empty?
      substructures
    end

    def self.bin_path
      Pathname(__FILE__).parent + 'SourceKitten/bin/sourcekitten'
    end
  end
end
