require_relative '../lib/hitbox'
describe Hitbox do
  describe "#circle" do
    it "should return true when its within the circle" do
      Hitbox.circle(coordinates: [30, 30], distance: 30).check(40,40).should be_true 
    end

    it "should return true when its outside the circle" do
      Hitbox.circle(coordinates: [30, 30], distance: 30).check(60,60).should_not be_true 
    end
  end

  describe "#rectangle" do
    it "should return true when its within the rectangle" do
      Hitbox.rectangle(hitbox: [0..50, 0..50]).check(25,25).should be_true
    end
  end
end
