
module Helper

  def get_git_root(project_path)
    current_dir = `pwd`
    project_dir = File.dirname project_path

    path = `cd #{project_dir};git rev-parse --show-toplevel;cd #{current_dir}`
    return path.strip
  end

end
