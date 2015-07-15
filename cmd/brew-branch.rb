# brew branch <formula>
#
# Switch to a branch called <formula> (creating it if necessary), then
# fix style errors and open the formula file in $EDITOR

require "formula"

def current_branch
  `git symbolic-ref HEAD`.gsub("refs/heads/", "").strip
end

def branch_edit(f)
  Dir.chdir f.path.dirname
  system "git", "checkout", "master"
  branches = `git branch | awk '{ print $1 }'`.split("\n")

  if current_branch != f.name
    args = ["checkout"]
    args << "-b" unless branches.include? f.name
    args << f.name

    system "git", *args
    return if current_branch != f.name
  end

  system "brew", "style", "--fix", f.name
  exec_editor(f.path)
end

if ARGV.size != 1
  odie <<-EOS.undent
    `brew branch` takes a single formula as its argument.
  EOS
else
  begin
    branch_edit Formulary.factory(ARGV.first)
  rescue FormulaUnavailableError
    raise
  end
end
