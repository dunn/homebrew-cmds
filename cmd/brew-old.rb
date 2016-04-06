# brew old [days] [--all] [--simple]
#
# List the installed formula that haven't been updated in however many
# days.
#
# If no number is given, 60 is used.
#
# If --all is used, check all tapped formula, not just those installed.
#
# If --simple is used, just print old formula names.

require "formula"
require "date"

if ARGV.flag? "--simple"
  @simple = true
  ARGV.delete "--simple"
end

if ARGV.flag? "--all"
  all = true
  ARGV.delete "--all"
end

@time_back = ARGV.first || 60
@date_limit = Date.today - @time_back.to_i

def check_old(f)
  f.path.dirname.cd do
    last_commit = `git log -n 1 --since=#{@date_limit} -- #{f.path}`
    if last_commit.empty?
      output = f.full_name
      unless @simple
        output << " hasn't been updated in #{@time_back} days"
      end
      puts output
    end
  end
end

if all
  Formula.each do |f|
    check_old f
  end
else
  Formula.installed.each do |f|
    check_old f
  end
end
