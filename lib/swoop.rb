require "swoop/version"
require "swoop/report"
require "swoop/project"
require "swoop/helper"
require "swoop/sourcekitten"

require "thor"
require 'xcodeproj'
require 'git'
require 'Logger'

module Swoop

  class Reporter < Thor
    include Helper

    # /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj
    # bundle exec bin/swoop report --path /Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj --folder 'Classes/Models'
    # bundle exec bin/swoop report --path spec/fixture/Swoop/Swoop.xcodeproj --folder 'Swoop/Model'

    desc "report", "Create objc swift comparison report for classes from an Xcode project"
    option :path
    option :folder
    def report
      project_path = options[:path]
      folder = options[:folder]

      create_report(project_path, folder)
    end

    private

    def create_report(project_path, dir_path)
      project = Project.new(project_path, dir_path)
      entities = project.filepaths.map { |path| create_entities(path) }.flatten
      report = Report.new(entities)

      puts report
    end

    # def summarise_report(project_path, folder)
    #   working_dir = get_git_root project_path
    #   g = Git.open(working_dir)
    #
    #   full_report = g.tags
    #   .select { |t| t.name.include?("v5") }
    #   .map { |t|
    #
    #     log = t.log.first
    #     g.checkout(log.sha)
    #
    #     date = log.date.strftime("%d-%m-%Y")
    #     report = create_report(project_path, folder)
    #
    #     "#{report} || #{date} (#{t.name})"
    #   }
    #
    #   g.branches[:master].checkout
    #
    #   report = create_report(project_path, folder)
    #   date = Time.now.strftime("%d-%m-%Y")
    #   full_report << "#{report} || #{date} (HEAD)"
    #
    #   puts "\nSwift Swoop Report  : '#{folder}'"
    #   puts "=="
    #   puts full_report
    #   puts "\n"
    #
    #   return 1
    # end


    private

    def create_entities(path)
      extension = File.extname(path)
      return create_swift_entities(path) if extension == ".swift"
      return create_objc_entities(path) if extension == ".h"
      []
    end

    def create_swift_entities(path)
      json_objects = SourceKitten.run(path)
      json_objects.map { |json| Entity.new_from_json(json) }
    end

    def create_objc_entities(path)
      filename = File.basename(path)
      type = filename.include?("+") ? "category" : "class"
      entity = Entity.new(filename, "objc", type)

      [ entity ]
    end

  end

end
