class Hitbox
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def self.method_missing(type, options = {})
    options[:type] = type
    instance = new(options)
    if instance.respond_to?("check_#{type}")
      instance
    end
  end

  def check(x, y)
    send("check_#{@options[:type]}", x, y)
  end

  def check_circle(x, y)
    Math.sqrt((options[:coordinates][0] - x)**2 + (options[:coordinates][1] -y)**2) < options[:distance]
  end

  def check_rectangle(x, y)
    options[:hitbox][0].include?(x) && options[:hitbox][1].include?(y)
  end
end
