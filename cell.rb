module GameOfLife
    class Cell
        attr_accessor :is_alive
        attr_accessor :is_alive_in_next_generation

        def initialize
            @is_alive = false
            @is_alive_in_next_generation = false
        end
    end
end