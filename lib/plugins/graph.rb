command :graph do |c|
  c.syntax = "graph [--professional] [--terse] [--out=location] FILE"
  c.description = "Outputs a graph to ./png/FILENAME.png by default"
  c.option "--professional", "Removes baseline markers"
  c.option "--terse", "Doesn't show raw data and baseline curve (just shows result)."
  c.option "--verbose", "Tell me all about what you're doing..."
  c.option "--out PATH", String, "Choose output location"
  c.option "--beamstop STOP", Float, "Location of beamstop"

  c.action do |args, options|
    options.default beamstop: 0
    if options.verbose
      def v str; puts str; end
    else
      def v str; end
    end

    args.map{|f| Dir[f]}.flatten.each do |f|
      v "Processing #{f}..."
      b = Baseline.new(f, beamstop:options.beamstop)
      v "  Signal has #{b.signal.size} points."
      g = GnuPlot.new(b)
      if options.professional
        g.show_baseline_markers = false
      end

      if options.terse
        g.show_baseline = false
        g.show_raw = false
      end

      g.output = OutputFormatter.new(f, path:options.out,ext:"png").to_s
      puts "Outputting graph to: #{g.output}"

      g.run!
    end
  end
end