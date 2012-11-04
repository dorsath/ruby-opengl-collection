require_relative '../../lib/tile'
require_relative '../../lib/grid'

describe Grid do
  it "should set the tile's position when it sets it in the grid" do
    tile = Tile.new
    subject.set_tile(tile, 1, 5)
    tile.position.should == [1,5]
  end
end
