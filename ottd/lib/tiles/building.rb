class Building < Tile
  def initialize(x, y)
    super
    @sprite = Sprite.load("building1.png", 1,2)
  end
end
