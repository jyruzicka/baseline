class Baseline
  attr_accessor :signal, :baseline, :knots

  def initialize(file, beamstop:0)
    # Initialise signal as a group of Points
    signal_arr = File.read(file).split("\n").map{ |line| line.split(/\s+/).map(&:to_f) }
    @signal = signal_arr.map{ |arr| Point.new(arr[0],arr[1]) }.sort
    @signal = @signal.select{ |p| p.x > beamstop }

    # Initialise knots as an array of knots, sorted and trimmed according to range
    baseline_file = File.basename(file, File.extname(file)) + ".baseline"
    knot_xs = File.exists?(baseline_file) ? File.read(baseline_file).split("\n").map(&:to_f) : []
    @knots = knot_xs.map{ |x| Knot.from_point self[x] }

    @knots += [Knot.from_point(@signal.first), Knot.from_point(@signal.last)]

    range = (@signal.first.x .. @signal.last.x)
    @knots = @knots.select{ |k| range.cover? k.x }.sort

    # Now assign region
    @regions = []
    1.upto(@knots.size - 1) do |i|
      sp = @knots[i-1]
      ep = @knots[i]
      @regions << Region.new(sp,ep)
    end

    # Assign this guy?
    @baseline = {}
  end

  def [] v
    raise ArgumentError, "Baseline#[] takes numbers, you passed #{v.inspect} (#{v.class})" unless v.kind_of?(Numeric)
    if p = @signal.find{ |p| p.x == v }
      p
    else
      low = @signal.select{ |p|  p.x < v }.max
      high = @signal.select{ |p| p.x > v }.min

      frx = (v - low.x) / (high.x - low.x)
      low.fraction_to(high,frx)
    end
  end

  #-------------------------------------------------------------------------------
  # Baseline functions

  def gradient_at x
    knot = @knots.find{ |k| k.x == x }
    raise RuntimeError, "Called gradient_at for #{x}, which is not a knot." unless knot
    knot.gradient
  end

  def baseline_at x
    if !@baseline.has_key?(x)
      knot = knot_at(x)
      @baseline[x] = if knot
        knot
      else
        # First find the region that this point belongs to
        r = @regions.find{ |r| r.contains? x }
        y = r[x]
        Point.new(x,y)
      end
    end
    @baseline[x]
  end

  def modified_value_at x
    signal.find{ |p| p.x == x }.y - baseline_at(x).y
  end

  def knot_at x
    @knots.find{ |k| k.x == x }
  end

  #-------------------------------------------------------------------------------
  # Output

  def complete
    @signal.map{ |p|
      x = p.x
      [x, p.y, baseline_at(x).y, modified_value_at(x)].join("\t")
    }.join("\n")
  end

  def terse
    @signal.map{ |p|
      x = p.x
      [x, modified_value_at(x)].join("\t")
      }.join("\n")
  end
end