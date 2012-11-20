require_relative '../../lib/texture'

describe Texture do

  it "should return the texture id when loading a texture" do
    Texture.load("grass.png").texture_id.should eql(1)
  end
  
  it "should not instantiate a new texture object if asked for a texture that has already been loaded" do
    Texture.load("building1.png")
    Texture.should_not_receive(:new)
    Texture.load("building1.png")
  end
end
