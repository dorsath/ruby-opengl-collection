class World
  def initialize
    load_world
  end

  def map_layout
   "pqptptptpwgggggggghghghggg
    plpupupuprgggggggghghghggg
    pdpfpgphpjgggggggghghghggg
    pcpvpbpnpmgggggggghghghggg
    gggggghghghggggggghghghggg
    gggggghghghggggggghghghggg
    gggggggggggggggggghghghggg
    gggghghghghghghghghghghggg
    gggghghghghghghghghghghggg
    gggghghghghghggggggggggggg"
  end

  def load_world
    @map = map_layout.gsub(' ', '').split(/\n/).map do |row|
      row.scan(/../).map { |tile| translate(tile) }
    end
  end
  
  def draw
    glScale(50,50,50)
    x = 0
    y = 0

    glEnable GL_TEXTURE_2D
    @map.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        glPushMatrix
        glTranslate(x,y,0)
        $sprites[*tile]
        glPopMatrix
      end
    end
    glDisable GL_TEXTURE_2D
  end

  def translate(sign)
    case sign
    when "gg"
      [3,3]
    when "hg"
      [35,2]
    when "pq"
      [0,4]
    when "pt"
      [1,4]
    when "pw"
      [4,4]
    when "pl"
      [0,5]
    when "pu"
      [2,5]
    when "pr"
      [4,5]
    when "pd"
      [0,6]
    when "pf"
      [1,6]
    when "pg"
      [2,6]
    when "ph"
      [3,6]
    when "pj"
      [4,6]
    when "pc"
      [0,7]
    when "pv"
      [1,7]
    when "pb"
      [2,7]
    when "pn"
      [3,7]
    when "pm"
      [4,7]
    else
      [30,30]
    end
  end
end
