require "formula"

def current_branch
  `git symbolic-ref HEAD`.gsub("refs/heads/", "").strip
end

def branch_edit(f)
  Dir.chdir f.path.dirname
  branches = `git branch | awk '{ print $1 }'`.split("\n")

  args = ["checkout"]
  args << "-b" unless branches.include? f.name
  args << f.name

  if current_branch != f.name
    system "git", *args
  end

  exec_editor(f.path)
end

if ARGV.size != 1
  odie <<-EOS.undent
    `brew branch` takes a single formula as its argument.
  EOS
elsif !Dir.pwd.include?(HOMEBREW_PREFIX)
  odie <<-EOS.undent
    Run `brew branch` from within your Homebrew repository.
  EOS
else
  begin
    branch_edit Formulary.factory(ARGV.first)
  rescue FormulaUnavailableError
    raise
  end
end
