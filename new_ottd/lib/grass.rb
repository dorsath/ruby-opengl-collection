require_relative 'tile'

class Grass < Tile
  def initialize
    @sprite = Texture.load("grass.png")
  end

  def draw
    @sprite.draw
  end
end
