require_relative '../../lib/tile.rb'

describe Tile do

  it "should hold its position" do
    subject.position = [0, 0]
    subject.position.should == [0, 0]
  end
end
