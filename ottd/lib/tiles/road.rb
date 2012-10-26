class Road < Tile
  def initialize(x = 0, y = 0)
    @sprite = Sprite.load("road.png", 1,1)
    super
  end
end
