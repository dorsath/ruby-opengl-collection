require_relative 'tile'

class Tiles

  attr_reader :tile

  def initialize
    @tile = Tile.new
  end


  def draw
    5.times do |x|
      5.times do |y|
        tile.draw(x,y)
      end
    end
  end
end
