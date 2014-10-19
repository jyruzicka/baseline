command :fit do |c|
  c.syntax = "fit [--terse] [--out=PATH] FILE"
  c.description = "Fits the file and outputs a shiny file with data."
  c.option "--terse", "Only output formatted data."
  c.option "--out PATH", "Output location. If not supplied, will output to stdout."

  c.action do |args, options|
    args.map{|f| Dir[f]}.flatten.each do |f|
      b = Baseline.new(f)

      if options.out
        output = OutputFormatter.new(f, path:options.out, ext:"txt")

        puts "Outputting data to: #{output}"
        File.open(output.to_s,"w") do |io|
          io.puts(options.terse ? b.terse : b.complete)
        end
      else
        puts(options.terse ? b.terse : b.complete)
      end
    end
  end
end

default_command :fit