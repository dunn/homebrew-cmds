require "formula"

def current_branch
  `git symbolic-ref HEAD`.gsub("refs/heads/", "").strip
end

def branch_edit(f)
  branches = `git branch | awk '{ print $1 }'`.split("\n")
  b = (branches.include? f.name) ? "" : "-b"

  Dir.chdir f.path.dirname
  system "git", "checkout", "#{b}", "#{f.name}" if current_branch != f.name

  exec_editor(f.path)
end

if ARGV.size != 1
  odie <<-EOS.undent
    `brew branch` takes a single formula as its argument.
  EOS
elsif !Dir.pwd.include? HOMEBREW_PREFIX
  odie <<-EOS.undent
    Run `brew branch` from within your Homebrew repository.
  EOS
else
  begin
    working_dir = Dir.pwd
    branch_edit Formulary.factory(ARGV.first)
  rescue FormulaUnavailableError
    raise
  ensure
    Dir.chdir working_dir
  end
end
