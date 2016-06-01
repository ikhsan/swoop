require 'pathname'
require 'shellwords'
require 'swoop/entity'

module Swoop
  module SourceKitten

    @file_path = ""

    def self.run(file_path)
      @file_path = file_path
      return run_swift if File.extname(@file_path) == ".swift"
      return run_objc if File.extname(@file_path) == ".h"
      ""
    end

    private

    def self.file_path
      @file_path.to_s
    end

    def self.swift_commands
      [bin_path, "doc", "--single-file", file_path, "--", "-j4", file_path]
    end

    def self.run_swift
      run_command(swift_commands)
    end

    def self.objc_commands
      [bin_path, "doc", "--objc", file_path, "--", "-x", "objective-c", "-isysroot", `xcrun --show-sdk-path --sdk iphonesimulator`.chomp, "-I", `pwd`]
    end

    def self.run_objc
      run_command(objc_commands)
    end

    def self.run_command(commands)
      require 'open3'

      stdin, stdout, stderr, wait_thr = Open3.popen3(*commands)
      response = stdout.read
      error = stderr.read

      stdin.close
      stdout.close
      stderr.close

      exit_status = wait_thr.value
      return response if exit_status.success?

      # TODO: handle error properly, why this doesn't work
      # puts file_path

      nil
    end

    def self.bin_path
      Shellwords.escape(Pathname(__FILE__).parent + 'SourceKitten/bin/sourcekitten')
    end

  end
end
