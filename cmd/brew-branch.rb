if !Dir.pwd.include? HOMEBREW_PREFIX
  odie <<-EOS.undent
    Run `brew branch` from within your Homebrew repository.
  EOS
else
  branches = `git branch`.split("\n")
  ohai branches.include? ARGV.first
end
