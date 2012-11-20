module Walker
  class Base

    def self.presentation_driver(driver)
      Base.driver = driver
    end


    def initialize
      driver.draw_hook = self
      @draw_items = []
    end

    def start(action)
      send(action)
      driver.start
    end

    def driver
      Base.driver
    end

    def draw
      @draw_items.each(&:draw)
    end

    def add(item)
      @draw_items << item
    end

    def mouse_handler(*args)
      @draw_items.reverse.each do |item|
        if item.respond_to?(:mouse_handler)
          break if item.mouse_handler(*args)
        end
      end
    end

    def self.driver
      @driver
    end

    def self.driver=(driver)
      @driver = driver
    end

  end
end
