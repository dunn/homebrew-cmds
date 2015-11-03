# brew md <formula>
#
# Generate Markdown links to formula files on GitHub

raise FormulaUnspecifiedError if ARGV.empty?

all = ""
ARGV.each do |formula|
  md = "[`#{formula}.rb`](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/#{formula}.rb)"
  puts md
  all += "#{md}\n"
end

`echo '#{all}' | pbcopy`
