require_relative "../lib/point"

describe Point do
  it "should store x and y" do
    p = Point.new(1,3)
    expect(p.x).to eq(1)
    expect(p.y).to eq(3)
  end
end