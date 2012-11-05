require_relative '../../lib/grid'
require_relative '../../lib/tile'

describe Grid do

  it "should translate to the tile's position on the grid in draw" do
    GL.should_receive(:Translate)
    subject.set_tile(Tile.new, 0, 0)
    subject.draw
  end

end
