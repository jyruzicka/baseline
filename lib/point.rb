class Point
  include Comparable
  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def fraction_to(point, frx)
    new_x = self.x + (point.x - self.x) * frx
    new_y = self.y + (point.y - self.y) * frx
    Point.new(new_x, new_y)
  end

  def <=> p
    self.x <=> p.x
  end
end