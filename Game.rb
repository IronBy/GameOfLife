require_relative 'life_area'

module GameOfLife
  CellIsOutsideOfLifeAreaError = Class.new(StandardError)
  InvalidLifeAreaSizeError = Class.new(StandardError)
  Cell = Class.new(Struct.new :alive, :alive_in_next_generation)

  class Game
    def initialize(area)
      fail ArgumentError, "area cannot be nil" unless area
      @area = area
    end

    def evolve
      @area.upgrade_generation do |alive, (row_index, column_index)|
        if alive
          !cell_dies?(row_index, column_index)
        else
          cell_revives?(row_index, column_index)
        end
      end
    end

    private

    def cell_dies?(row_index, column_index)
      alive_neighbours_count = @area.get_alive_neighbours_count(row_index, column_index)
      alive_neighbours_count < 2 || alive_neighbours_count > 3
    end

    def cell_revives?(row_index, column_index)
      @area.get_alive_neighbours_count(row_index, column_index) == 3
    end
  end
end
