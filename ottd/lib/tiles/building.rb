class Building < Tile
  def initialize(x, y, tiles = nil)
    super
    @sprite = Sprite.load("building#{rand(1..2)}.png", 1,2)
  end
end
