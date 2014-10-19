require_relative "point"

class Knot < Point
  attr_reader :region_below, :region_above

  def self.from_point(p)
    new(p.x,p.y)
  end

  def region_below= r
    @region_below = r
    r.end_point = self if r && r.end_point != self
  end

  def region_above= r
    @region_above = r
    r.start_point = self if r && r.start_point != self
  end

  def gradient
    gs = [region_below && region_below.gradient, region_above && region_above.gradient].compact
    gs.reduce(&:+) / gs.size
  end
end