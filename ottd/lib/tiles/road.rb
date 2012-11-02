class Road < Tile
  attr_reader :tiles

  def initialize(x = 0, y = 0, tiles = nil)
    @tiles = tiles
    @sprite = Sprite.load("roads/road_sl.png", 1,1)
    super

    flag_for_recheck
  end

  def flag_for_recheck
    @recheck = true
  end

  def draw
    recheck?

    super
  end

  def recheck?
    if @recheck
      check_for_adjacent_roads(true)
      @recheck = false
    end
  end

  def check_for_adjacent_roads(recheck = false)
    results = adjacent_tiles

    sprite_based_on_adjecant_tiles(results)

    if recheck
      results.each do |result|
        result.check_for_adjacent_roads if result.is_a?(Road)
      end
    end
  end

  def sprite_based_on_adjecant_tiles(tiles)
    case(tiles.map { |d| d.is_a?(Road)})
    when [true, true, true, true]
      @sprite = Sprite.load("roads/road_xx.png")
    when [true, true, false, false]
      @sprite = Sprite.load("roads/road_ct.png")
    when [true, false, false, true]
      @sprite = Sprite.load("roads/road_cl.png")
    when [false, true, true, false]
      @sprite = Sprite.load("roads/road_cr.png")
    when [false, false, true, true]
      @sprite = Sprite.load("roads/road_cb.png")
    when [true, true, true, false]
      @sprite = Sprite.load("roads/road_ttr.png")
    when [true, true, false, true]
      @sprite = Sprite.load("roads/road_ttl.png")
    when [false, true, true, true]
      @sprite = Sprite.load("roads/road_tbr.png")
    when [true, false, true, true]
      @sprite = Sprite.load("roads/road_tbl.png")
    when [true, false, false, false], [true, false, true, false], [false, false, true, false]
      @sprite = Sprite.load("roads/road_sl.png")
    when [false, true, false, false], [false, true, false, true], [false, false, false, true]
      @sprite = Sprite.load("roads/road_sr.png")
    end

  end
end
