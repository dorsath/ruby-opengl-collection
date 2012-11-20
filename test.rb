require 'mongo'
connection = Mongo::Connection.new

db  = connection.db("ottd")
$map = map = db.collection("map")

$dimensions = [10, 10, 10]

p "connected to ottd"

def show_records
  $map.find.each do |row|
    p row
  end
end

class Point
  attr_accessor :x, :y, :z, :name

  def initialize(*args)
    @x, @y, @z, @name = args
  end


  def self.create(values)
    Point.new(*values.values).save
  end

  def save
    $map.insert(params)
  end

  private

  def params
    {x: x, y: y, z: z, name: name}
  end
end

$dimensions[0].times do |x|
  $dimensions[1].times do |y|
    $dimensions[2].times do |z|
      Point.create(x: x, y: y, z: z, name: "lo")
    end
  end
end

def find_highest_level_at_camera(z)
  results = []
  $dimensions[0].times do |x|
    $dimensions[1].times do |y|
      results << $map.find(x: x, y: y, z: {"$lte" => z}).sort(z: :desc).limit(1).first
    end
  end
  results.count
end

def benchmark
  benchmark = Time.now.to_f
  yield
  p Time.now.to_f - benchmark
end

# benchmark do 
#   p find_highest_level_at_camera(20)
# end
# 
# benchmark do
#   p $map.find_one(x: 5, y: 7)
# end

reduce = "function(key, values) {
  var old = 0;
  values.forEach(function(doc)){
    old += 1
  }

  return {highest: old};
  }"

op =  $map.map_reduce("function(){ emit(this.y, this.highest) }", reduce, out: "mr_results")
p op.find_one
# p op.result].find

# benchmark do
# p $map.distinct(:x, :y)
# end


p "cleaning up the #{map.count} elements before deletion"
map.remove
p map.count
