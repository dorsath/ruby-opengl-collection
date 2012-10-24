require_relative 'tile'
class Tiles
  def draw
    5.times do |x|
      5.times do |y|
        Tile.new(x,y)
      end
    end
  end
end
