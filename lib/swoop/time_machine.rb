require 'git'

module Swoop

  class TimeMachine

    attr_reader :project

    def initialize(project, options)
      @project = project
      @tags = options[:tags] || 10
      @weeks = options[:weeks] || 20
    end

    def project_path
      @project_path ||= @project.path
    end

    def travel
      # TODO: get current branch
      current_branch = :master

      logs.each do |t|
        log = t.log.first
        git.checkout(log.sha)
        yield(project, t.name, log.date)
      end

      git.branches[current_branch].checkout
    end

    private

    def get_git_root
      current_dir = `pwd`
      project_dir = File.dirname(project_path)

      path = `cd #{project_dir};git rev-parse --show-toplevel;cd #{current_dir}`
      path.strip
    end

    def git
      @git ||= Git.open(get_git_root)
    end

    def logs
      if @tags > 0
        git.tags.select { |e| e.name.match('^v\d+.\d+') }.sort { |a, b| a.log.first.date <=> b.log.first.date }.last(@tags)
      elsif @weeks > 0
        # TODO: get logs for last n weeks
        nil
      end
    end
  end


end
