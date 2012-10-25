require_relative 'tile'

class Tiles

  def initialize
    # @tile = Tile.new
    @building = Tile.new("building1.png", 1,2)
  end


  def draw
    @building.draw(2,0)
    @building.draw(1,0)
    @building.draw
    # 5.times do |x|
    #   5.times do |y|
    #   end
    # end
  end
end
