require_relative 'tile'

class Tiles

  def initialize
    # @tile = Tile.new
    @buildings = [
      Tile.new("building1.png", 1,2),
      Tile.new("building2.png", 1,2)
    ]
    @road = Tile.new("road.png", 1,1)
  end


  def draw
    @buildings[0].draw(2,1)
    @buildings[1].draw(1,1)
    (1..5).to_a.reverse.each do |x|
      @road.draw(x,0)
    end
  end
end
