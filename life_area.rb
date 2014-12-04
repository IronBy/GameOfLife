require_relative "./invalid_life_area_size_error"
require_relative "./cell_is_outside_of_life_area_error"
require_relative "./cell"

module GameOfLife
  class LifeArea
    attr_reader :width
    attr_reader :height

    def initialize(width, height)
      verify_area_size(width, height)
      @width = width
      @height = height

      @area = create_empty_area(width, height)
    end

    def mark_cell_as_alive(row_index, column_index)
      verify_is_in_life_area(row_index, column_index)
      @area[row_index][column_index].is_alive = true
    end

    def is_cell_alive?(row_index, column_index)
      return is_in_life_area?(row_index, column_index) &&
        @area[row_index][column_index].is_alive
    end

    def get_alive_neighbours_count(row_index, column_index)
      return count_aliveness(row_index - 1, column_index - 1) +
        count_aliveness(row_index - 1, column_index) +
        count_aliveness(row_index - 1, column_index + 1) +
        count_aliveness(row_index , column_index - 1) +
        count_aliveness(row_index, column_index + 1) +
        count_aliveness(row_index + 1, column_index - 1) +
        count_aliveness(row_index + 1, column_index) +
        count_aliveness(row_index + 1, column_index + 1)
    end

    def mark_dead_in_next_generation(row_index, column_index)
      @area[row_index][column_index].is_alive_in_next_generation = false
    end

    def mark_alive_in_next_generation(row_index, column_index)
      @area[row_index][column_index].is_alive_in_next_generation = true
    end

    def upgrade_generation
      @area.each { |row|
        row.each { |cell| cell.is_alive = cell.is_alive_in_next_generation}
      }
    end

    private
    def verify_area_size(width, height)
      raise InvalidLifeAreaSizeError.new if width <= 0 || height <= 0
    end

    def verify_is_in_life_area(row_index, column_index)
      raise CellIsOutsideOfLifeAreaError.new if !is_in_life_area?(row_index, column_index)
    end

    def is_in_life_area?(row_index, column_index)
      return row_index >= 0 && row_index < @height &&
        column_index >= 0 && column_index < @width
    end

    def create_empty_area(width, height)
      Array.new(height) { Array.new(width) { Cell.new } }
    end

    def count_aliveness(row_index, column_index)
      return 0 if !is_in_life_area?(row_index, column_index)
      return @area[row_index][column_index].is_alive ? 1 : 0
    end
  end
end