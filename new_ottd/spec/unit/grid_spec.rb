require_relative '../../lib/grid'

describe Grid do
  it "can set something in at a certain position" do
    tile = double
    tile.stub(:position=)
    subject.set_tile(tile, 0, 0)
    subject.get_tile(0, 0).should == tile
    subject.get_tile(0, 1).should be_nil
  end

  describe "#coordination handeling" do 
    it "should return the origin when holding the mouse at the bottom center" do
      subject.grid_position_from_coordinates(320, 454).should == [0, 0]
    end

    it "should know the position on the grid when given the coordinates of the mouse" do
      subject.grid_position_from_coordinates(320, 432).should == [1, 1]
      subject.grid_position_from_coordinates(288, 448).should == [1, 0]
    end
  end
end
