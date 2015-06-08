require "formula"

def print_urls(f)
  puts "#{Tty.em}#{f.name}.rb#{Tty.reset}"
  %w[stable bottle devel head].each do |source|
    if f.send(source)
      url = "#{Tty.white}#{source}#{Tty.reset}"
      url += "\t"
      url += f.send(source).url
      if source != "bottle" && f.send(source).specs
        url += " #{f.send(source).specs.to_s.gsub!(/[\{\}]/,"")}"
      end
      puts url
    end
  end
end

raise FormulaUnspecifiedError if ARGV.empty?

ARGV.each do |formula|
  begin
    print_urls(Formulary.factory(formula))
  rescue FormulaUnavailableError
    raise
  end
end
