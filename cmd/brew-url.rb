# brew url <formula>
#
# List the associated URLs for the given formulae: main download link,
# head, devel, bottle for the current OS.

require "formula"

def print_urls(f)
  puts "#{Tty.em}#{f.name}.rb#{Tty.reset}"
  %w[stable bottle devel head].each do |source|
    next unless f.send(source)
    url = "#{Tty.white}#{source}#{Tty.reset}"
    url += "\t"
    url += f.send(source).url
    if source != "bottle" && f.send(source).specs
      url += " #{f.send(source).specs.to_s.gsub!(/[\{\}]/,"")}"
    end
    puts url
  end
end

raise FormulaUnspecifiedError if ARGV.empty?

ARGV.each do |formula|
  begin
    print_urls(Formulary.factory(formula))
  rescue FormulaUnavailableError
    puts "No formula named '#{formula}'."
  end
end
