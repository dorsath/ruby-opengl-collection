class Citizen
  attr_reader :position

  def initialize(options)
    @position = options[:position]
  end

end
