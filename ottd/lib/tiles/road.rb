class Road < Tile
  attr_reader :tiles

  def initialize(x = 0, y = 0, tiles = nil)
    @tiles = tiles
    @sprite = Sprite.load("roads/road_sl.png", 1,1)
    super

    check_for_adjacent_roads(true) if tiles
  end

  def check_for_adjacent_roads(recheck = false, asking = [])
    adjacent_offsets = [ [-1,0], [0, -1], [1, 0], [0, 1] ]
    roads = []

    results = adjacent_offsets.map do |offsets|
      tile = tiles.get_tile(@x + offsets[0], @y + offsets[1])
      if tile.is_a?(Road)
        roads << tile
        true
      else
        roads << false
        false
      end
    end

    if asking.any?
      results[adjacent_offsets.index(asking)] = true
    end

    case(results)
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


    if recheck
      roads.each_with_index do |road, index|
        road.check_for_adjacent_roads(false, adjacent_offsets[index - 2]) if road
      end
    end
  end
end
