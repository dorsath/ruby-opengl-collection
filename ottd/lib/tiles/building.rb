class Building < Tile
  def initialize(x = 0, y = 0, tiles = nil)
    super
    @sprite = Sprite.load("building#{rand(1..2)}.png", 1,2)
  end
end
