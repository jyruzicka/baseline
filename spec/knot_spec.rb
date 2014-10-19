require_relative "../lib/knot.rb"

describe Knot do
  it "should init like a point" do
    k = Knot.new(1,3)
    expect(k.x).to eq(1)
  end

  it "should auto-set region's points" do
    k = Knot.new(1,3)
    r = double("Region")
    expect(r).to receive(:start_point).and_return(nil)
    expect(r).to receive(:start_point=).with(k)
    k.region_above = r

    s = double("Region")
    expect(s).to receive(:end_point).and_return(nil)
    expect(s).to receive(:end_point=).with(k)
    k.region_below = s
  end

  it "should not auto-set when not required" do
    k = Knot.new(1,3)
    r = double("Region")
    expect(r).to receive(:start_point).and_return(k)
    k.region_above = r

    s = double("Region")
    expect(s).to receive(:end_point).and_return(k)
    k.region_below = s
  end

  it "should average gradients" do
    k = Knot.new(1,3)
    ra = double("Region", start_point: k, gradient: 1.0)
    rb = double("Region", end_point: k, gradient: 0.0)
    k.region_above = ra
    k.region_below = rb

    expect(k.gradient).to eq(0.5)

    k.region_below = nil
    expect(k.gradient).to eq(1)
  end
end