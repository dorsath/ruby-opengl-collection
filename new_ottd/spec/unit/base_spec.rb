require_relative '../../lib/base'

describe Base do
  it "should accept new things to render" do
    grid = double
    subject.add_draw_item(grid)
    subject.draw_items.should include grid
    grid.should_receive(:draw)
    subject.draw
  end
end
