require "formula"
include FileUtils

def go_get(f)
  old_gopath = ENV["GOPATH"]
  old_gobin = ENV["GOBIN"]
  mktemp(f.name) do
    system "brew", "unpack", f.name

    cd "#{f.name}-#{f.version}" do
      ENV["GOPATH"] = Pathname.pwd
      ENV["GOBIN"] = Pathname.pwd.join("bin")
      mkdir_p ENV["GOBIN"]
      system "go", "get", "-v"
      deps = Utils::JSON.load(`go list -e -json`)
      puts Utils::JSON.dump(deps)
    end
  end
ensure
  ENV["GOPATH"] = old_gopath
  ENV["GOBIN"] = old_gobin
end

if ARGV.size != 1
  odie <<-EOS.undent
    `brew go` takes a single formula as its argument.
  EOS
else
  begin
    go_get Formulary.factory(ARGV.first)
  rescue FormulaUnavailableError
    raise
  end
end
