require_relative '../lib/sprite'

module Walker
  class Base
  end
end

class Towns < Walker::Base
  def self.driver
    @driver
  end

  def self.driver=(driver)
    @driver = driver
  end
end


# describe Sprite do
#   before do
#     driver = double
#     driver.stub(:textures)
# 
#     Towns.driver = driver
#   end
# 
#   it "should find a sprite source image" do
#     Sprite.load_source("items.png").should be_a(Magick::ImageList)
#   end
# 
#   it "should return a part of an image when given the image source and the coordinates and dimensions" do
#     sprite = Sprite.find("items.png", 9, 0, 46, 26)
#     sprite.should be_a(Sprite)
#     sprite.dimensions.should eql [46,26]
#   end
# 
#   it "shouldn't return a sprite if the coordinates are outside of the image" do
#     Sprite.find("items.png", 1200, 0, 40, 40).should be_nil
#   end
# 
#   it "should register the texture to the current driver" do
#     $driver.should_receive(:register_texture)
# 
#     Sprite.find("items.png", 0, 0, 40, 40)
#   end
# end
