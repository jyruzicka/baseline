class Region
  attr_reader :start_point, :end_point

  def initialize(start_point=nil, end_point=nil)
    self.start_point = start_point
    self.end_point = end_point 
  end

  def start_point= sp
    @start_point = sp
    sp.region_above = self if sp && sp.region_above != self
  end

  def end_point= ep
    @end_point = ep
    ep.region_below = self if ep && ep.region_below != self
  end

  def contains?(p)
    p = p.x if p.is_a?(Point)
    return  (@start_point.nil? || p >= @start_point.x) &&
            (@end_point.nil? || p <= @end_point.x)
  end

  # Value t: the fraction between points that a value lies
  def t(x)
    case true
    when start_point.nil?
      nil
    when end_point.nil?
      nil
    when !self.contains?(x)
      nil
    when x == start_point.x
      0.0
    when x == end_point.x
      1.0
    else # must lie within region, not start or end
      interval = end_point.x - start_point.x
      interval_fraction = x - start_point.x
      interval_fraction / interval
    end
  end

  # Find the value in a region at a given value x
  # Spline fit
  def [] x
    t = self.t(x)
    if t.nil?
      raise RuntimeError, "Region#[] called for a region with undefined end points, or x lies outside end points."
    end

    if t == 0.0
      start_point.y
    elsif t == 1.0
      end_point.y
    else
      k1 = start_point.gradient
      k2 = end_point.gradient

      y1 = start_point.y
      y2 = end_point.y

      x1 = start_point.x
      x2 = end_point.x

      a = k1 * (x2 - x1) - (y2 - y1)
      b = -k2 * (x2 - x1) + (y2 - y1)

      (1 - t) * y1 + t * y2 + t * (1 - t) * (a * (1 - t) + b * t)
    end
  end

  # Straight-line gradient across the region
  def gradient
    if end_point && start_point
      (end_point.y - start_point.y) / (end_point.x - start_point.x)
    else
      nil
    end
  end
end