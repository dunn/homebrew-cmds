require "formula"
require "date"

HOMEBREW_REPOSITORY.cd do
  Formula.installed.each do |f|
    if f.core_formula?
      git_dir = "#{HOMEBREW_REPOSITORY}/.git"
      formula_path = f.path
    else
      formula_path = f.path.basename
      # taps don't always have a 'Formula' directory
      if Dir["#{f.path.dirname}/.git/*"].empty?
        git_dir = "#{f.path.dirname.parent}/.git"
      else
        git_dir = "#{f.path.dirname}/.git"
      end
    end

    time_back = ARGV.first || 60
    date_limit = Date.today - time_back.to_i

    local_commit_time = `git --git-dir=#{git_dir} log -n 1 --since=#{date_limit} --pretty=format:%cd --date=local -- #{formula_path}`
    if local_commit_time.empty?
      puts "#{f.full_name} hasn't been updated in #{time_back} days"
    end
  end
end
