require 'git'

module Swoop

  class TimeMachine

    attr_reader :project

    def initialize(project, options)
      @project = project
      @tags = options[:tags] || 8
      @weeks = options[:weeks] || 0
      @filter = options[:filter]
    end

    def project_path
      @project_path ||= @project.path
    end

    def travel
      current_branch = git.current_branch

      logs.each do |t|
        log = t.log.first
        git.checkout(log.sha)
        yield(project, t.name, log.date)
      end

      git.branches[current_branch].checkout
      yield(project, current_branch, Time.now)
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
      return logs_by_week if @weeks > 0
      logs_by_tags
    end

    def logs_by_tags
      filtered_tags = git.tags
      filtered_tags = filtered_tags.select { |e| e.name.match(@filter) } unless @filter.nil? || @filter.empty?

      filtered_tags
        .sort { |a, b| a.log.first.date <=> b.log.first.date }
        .last(@tags)
    end

    def logs_by_week
      log = git.log(5000).since("#{@weeks+1} weeks ago")

      logs = []
      (0..log.size-1).each { |i| logs << log[i] }

      logs
        .reduce({}) { |memo, l|
          week = l.date.strftime('%W')
          memo[week] = l
          memo
        }
        .values
        .reverse
    end

  end

end
