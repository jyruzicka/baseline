require_relative "../lib/region"

describe Region do
   it "should auto-set knots's regions" do
    r = Region.new

    k = double("Knot")
    expect(k).to receive(:region_above).and_return(nil)
    expect(k).to receive(:region_above=).with(r)
    r.start_point = k

    l = double("Knot")
    expect(l).to receive(:region_below).and_return(nil)
    expect(l).to receive(:region_below=).with(r)
    r.end_point = l
  end

  it "should auto-set when not required to" do
    r = Region.new

    k = double("Knot")
    expect(k).to receive(:region_above).and_return(r)
    r.start_point = k

    l = double("Knot")
    expect(l).to receive(:region_below).and_return(r)
    r.end_point = l
  end

  it "should detect if points are contained" do
    r = Region.new
    r.start_point = double("Point", x:1, region_above:r)
    r.end_point =  double("Point", x:3, region_below:r)
    
    too_small   = double("Point", x:0)
    borderline  = double("Point", x:1)
    inside      = double("Point", x:2)
    too_large   = double("Point", x:4)

    expect(r).to be_contain(borderline)
    expect(r).to be_contain(inside)
    expect(r).to_not be_contain(too_small)
    expect(r).to_not be_contain(too_large)
  end
end