require_relative 'tile'

class Tiles

  def initialize
    # @tile = Tile.new
    @buildings = [
      Tile.new("building1.png", 1,2),
      Tile.new("building2.png", 1,2)
    ]
  end


  def draw
    @buildings[0].draw(2,0)
    @buildings[1].draw(1,0)
    @buildings[0].draw
    # 5.times do |x|
    #   5.times do |y|
    #   end
    # end
  end
end
