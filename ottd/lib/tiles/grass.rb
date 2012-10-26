class Grass < Tile
  def initialize(x = 0, y = 0, tiles = nil)
    @sprite = Sprite.load("grass.png", 1,1)
    super
  end
end
