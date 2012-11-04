require_relative '../../lib/grid'

describe Grid do
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
