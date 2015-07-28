# brew history <formula>
#
# Print the history of FORMULA: when it was added and removed
#
# Currently only works for formula in core (for consistency, since
# that's the only one everyone has tapped).

require "formula"
require "time"

odie "Specify a formula to investigate" if ARGV.empty?

unless (HOMEBREW_REPOSITORY/".git").exist?
  odie <<-EOS.undent
    Your Homebrew installation is not a git repository.

    To remedy this (will overwrite your local changes):

    cd #{HOMEBREW_REPOSITORY}
    git remote add origin https://github.com/Homebrew/homebrew.git
    git fetch origin
    git reset --hard origin/master
  EOS
end

# the dash between hash and unixtime in --format is used in .split("-") below
git_args = %w[log --reverse --format="%H-%at" --diff-filter=AD]

HOMEBREW_LIBRARY.cd do
  ARGV.named.each do |f|
    puts "#{Tty.em}#{f}.rb#{Tty.reset}"
    f_args = Array.new(git_args) << "--" << "Formula/#{f}.rb"
    commits = `git #{f_args.join(" ")}`.strip.split("\n")
    commits.each_with_index do |elem, index|
      # split into array with hash and time
      commit = elem.split("-")
      ctime = Time.at(commit[1].to_i).strftime("%Y-%m-%d")
      if index == 0
        puts "#{Tty.white}Added#{Tty.reset} on #{ctime} in Homebrew/homebrew@#{commit[0]}"
      else
        # get the diff of tap_migrations from the commit where the formula was deleted
        migrations = `git diff #{commit[0]}~1..#{commit[0]} -- Homebrew/tap_migrations.rb`.strip.split("\n")
        new_tap = migrations.select { |s| s.include?("\"#{f}\"") }.to_s
        new_tap = %r{(?<=\=\>)[^a-zA-Z]*([^\\]*\/[^\\]*)}.match(new_tap).captures[0]
        if new_tap
          puts "#{Tty.white}Moved#{Tty.reset} to #{new_tap} on #{ctime} in Homebrew/homebrew@#{commit[0]}"
        else
          puts "#{Tty.white}Removed#{Tty.reset} on #{ctime} in Homebrew/homebrew@#{commit[0]}"
        end
      end
    end
  end
end
