class Sprite

  TILE_SIZE = 32

  attr_reader :dimensions, :image_file, :tile_list

  def initialize(image_file, *dimensions)
    @dimensions = dimensions
    @image_file = image_file

    @texture   = load_texture
    @tile_list = load_list

    save
  end

  def save
    @@sprites ||= {}
    @@sprites[@image_file] = self
  end

  def self.load(image_file, x = 1, y = 1)
    @@sprites ||= {}

    if @@sprites[image_file]
      @@sprites[image_file]
    else
      Sprite.new(image_file, x, y).save
    end
  end

  def draw(x = 0,y = 0)
    color = [1,1,1]

    glPushMatrix
    glTranslate(320, 480, 0)
    glTranslate(TILE_SIZE * -x + TILE_SIZE * y, (TILE_SIZE * -x + TILE_SIZE * -y) * r2 , 0)

    glColor(*color)
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
    glEnable GL_BLEND
    glEnable GL_TEXTURE_2D
    glCallList(@tile_list)
    glDisable GL_TEXTURE_2D
    glDisable GL_BLEND

    yield(self) if block_given?

    glPopMatrix
  end

  def draw_highlight
    glBegin(GL_LINE_LOOP) do
      glVertex(0,0)
      glVertex(-TILE_SIZE,-TILE_SIZE*r2)
      glVertex(0, -TILE_SIZE)
      glVertex( TILE_SIZE, -TILE_SIZE*r2)
    end
  end

  def load_texture
    @source = Magick::ImageList.new(File.expand_path("../../textures/#{image_file}", __FILE__))

    transparent_pixel = Magick::Pixel.new
    transparent_pixel.opacity = 65408

    @source.first.each_pixel do |pixel, x, y|
      if pixel.hash == 65408
        @source.first.store_pixels(x,y,1,1, [transparent_pixel])
      end
    end

    image_data = @source.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    texture = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, @source.columns, @source.rows, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    texture
  end

  def load_list
    x, y = dimensions
    width  = @source.columns.to_f
    height = @source.rows.to_f

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
    y2 = -height

    tx0 = x1.abs/width
    ty1 = 1 - y1.abs/height
    ty3 = 1 - y3.abs/height

    glBindTexture(GL_TEXTURE_2D, @texture)
    # glBegin(GL_LINE_LOOP) do
    glBegin(GL_POLYGON) do

      glTexCoord2d(tx0,1)
      glVertex(x0, y0)

      glTexCoord2d(0,ty1)
      glVertex(x1, y1)

      glTexCoord2d(0,0)
      glVertex(x1, y2)

      glTexCoord2d(1,0)
      glVertex(x3, y2)

      glTexCoord2d(1,ty3)
      glVertex(x3, y3)
    end

    glEndList

    tile_list
  end

  #compensation for tilting the z axis 45 degrees
  def r2 
    0.5 #apparently not 0.5 * sqrt(2)
  end
end

