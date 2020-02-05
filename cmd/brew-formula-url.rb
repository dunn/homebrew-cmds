# brew md <formula>
#
# Generate Markdown links to formula files on GitHub

require "cmd/info"

raise FormulaUnspecifiedError if ARGV.empty?

ARGV.each do |formula|
  begin
    f = Formulary.factory(formula)
    remote = f.tap.remote
    path = f.path.relative_path_from(f.tap.path)
    puts Homebrew.github_remote_path(remote, path)
  rescue FormulaUnavailableError
    puts "No formula called '#{formula}'."
  end
end
