require_relative '../../lib/tile.rb'

describe Tile do

  it "should hold its position" do
    subject.position = [0, 0]
    subject.position.should == [0, 0]
  end

  it "should hold the current occupation" do
    occupation = double
    subject.occupation = occupation
    subject.occupation.should == occupation
  end
end
