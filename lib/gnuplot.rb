require "tempfile"

class GnuPlot
  attr_accessor :baseline, :output,
                :show_baseline_markers, :show_baseline, :show_raw

  def initialize b
    @baseline = b
    @show_baseline_markers = true
    @show_raw = true
    @show_baseline = true
  end

  def run!
    t = Tempfile.new("baseline")
    t.puts baseline.complete
    t.close

    raise RuntimeError, "Attempted to run instance of GnuPlot without setting output." if !output
    gnuplot_file = []
    gnuplot_file << "set terminal png enhanced truecolor size 1024,768" <<
      %|set output "#{output}"| <<
      "set border 3 lw 2" <<
      %|set tics nomirror font "Arial,18pt"| <<
      "unset ytics" <<
      %|set xlabel "Q [Å^{-1}]" font "Arial,24pt"| <<
      %|set ylabel "Intensity [arb. units]" font "Arial,24pt"| <<
      "set lmargin 5"

    if show_baseline_markers
      gnuplot_file << %|do for [i in "#{baseline.knots.map(&:x).join(" ")}"] {set arrow from i,0 to i,graph 1.0 nohead lc rgb "grey50"}|
    end

    if show_raw && show_baseline
      gnuplot_file <<
        %|plot  "#{t.path}" using 1:2 with lines title "Raw data",\\| <<
        %|"#{t.path}" using 1:3 with lines title "Baseline",\\| <<
        %|"#{t.path}" using 1:4 with lines title "Modified data"|
    elsif show_raw
      gnuplot_file <<
        %|plot  "#{t.path}" using 1:2 with lines title "Raw data",\\| <<
        %|"#{t.path}" using 1:4 with lines title "Modified data"|
    elsif show_baseline
      gnuplot_file <<
        %|plot "#{t.path}" using 1:3 with lines title "Baseline",\\| <<
        %|"#{t.path}" using 1:4 with lines title "Modified data"|
    else
      gnuplot_file <<
        "unset key" <<
        %|plot "#{t.path}" using 1:4 with lines title "Modified data"|
    end

    graph_t = Tempfile.new("baseline-gnuplot")
    graph_t.puts gnuplot_file.join("\n")
    graph_t.close
    `gnuplot #{graph_t.path}`
  end
end