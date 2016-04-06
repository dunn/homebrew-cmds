# brew md <formula>
#
# Generate Markdown links to formula files on GitHub

require "cmd/info"

raise FormulaUnspecifiedError if ARGV.empty?

all = ""
ARGV.each do |formula|
  begin
    f = Formulary.factory(formula)
    remote = f.tap.remote
    path = f.path.relative_path_from(f.tap.path)
    md = "[`#{f}.rb`](#{Homebrew.github_remote_path(remote, path)})"
    puts md
    all += "#{md}\n"
  rescue FormulaUnavailableError
    puts "No formula called '#{formula}'."
  end
end

`echo '#{all.strip}' | pbcopy`
