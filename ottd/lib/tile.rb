class Tile

  ALPHA_COLOR = [0, 257, 65535]
  TILE_SIZE = 32

  attr_reader :dimensions, :image_file

  def initialize(image_file, *dimensions)
    @dimensions = dimensions
    @image_file = image_file

    @texture   = load_texture
    @tile_list = load_list
  end

  def draw(x = 0,y = 0)
    color = [1,1,1]

    glPushMatrix
    glTranslate(320, 480, 0)
    glTranslate(TILE_SIZE * -x + TILE_SIZE * y, (TILE_SIZE * -x + TILE_SIZE * -y) * r2 , 0)

    glColor(*color)
    glCallList(@tile_list)
    glPopMatrix
  end

  def load_texture
    @source = Magick::ImageList.new(File.expand_path("../../textures/#{image_file}", __FILE__))
    # p @source.first.class
    # p [@source.columns, @source.rows]
    image_data = @source.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    texture = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, @source.rows, @source.columns, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    texture
  end

  def load_list
    x, y = dimensions

    tile_list = glGenLists(1)
    glNewList(tile_list, GL_COMPILE)

    # these are relative to x,y with the axis as down == positive the tile 
    #  x1,y2---x3,y2
    #    |      |
    #    |      x3,y3
    #  x1,y1   /
    #     \   /
    #      x,y

    x0 = 0
    y0 = 0
    x1 = TILE_SIZE * -x
    y1 = TILE_SIZE * -x * r2 
    x3 = TILE_SIZE *  y
    y3 = TILE_SIZE * -y * r2
    y2 = -@source.rows

    glBegin(GL_LINE_LOOP) do
    # glBegin(GL_POLYGON) do
      glVertex(x0, y0)
      glVertex(x1, y1)
      glVertex(x1, y2)
      glVertex(x3, y2)
      glVertex(x3, y3)
    end

    glEndList

    tile_list
  end

  #compensation for tilting the z axis 45 degrees
  def r2 
    0.5 * Math.sqrt(2)
  end
end
