module GameOfLife
  class LifeArea < Struct.new :width, :height

    def initialize(width, height)
      fail InvalidLifeAreaSizeError if width <= 0 || height <= 0
      super

      @area = create_empty_area(width, height)
    end

    def mark_cell_as_alive(row_index, column_index)
      verify_is_in_life_area(row_index, column_index)
      @area[row_index][column_index].alive = true
      self
    end

    def cell_alive?(row_index, column_index)
      in_life_area?(row_index, column_index) && @area[row_index][column_index].alive
    end

    def get_alive_neighbours_count(row_index, column_index)
      (-1..1).map do |row|
        (-1..1).map do |column|
          [row, column].all?(&:zero?) ? 0 : count_aliveness(row_index + row, column_index + column)
        end.sum
      end.sum
    end

    def mark_in_next_generation(state, row_index, column_index)
      self.tap { @area[row_index][column_index].alive_in_next_generation = state }
    end

    def upgrade_generation
      height.times do |row_index|
        width.times do |column_index|
          mark_in_next_generation(yield(cell_alive?(row_index, column_index), [row_index, column_index]), row_index, column_index)
        end
      end

      @area.each { |row| row.each { |cell| cell.alive = cell.alive_in_next_generation } }
      self
    end

    private

    def verify_is_in_life_area(row_index, column_index)
      fail CellIsOutsideOfLifeAreaError if !in_life_area?(row_index, column_index)
    end

    def in_life_area?(row_index, column_index)
      (0...height).cover?(row_index) && (0...width).cover?(column_index)
    end

    def create_empty_area(width, height)
      Array.new(height) { Array.new(width) { Cell.new(false, false) } }
    end

    def count_aliveness(row_index, column_index)
      return 0 unless in_life_area?(row_index, column_index)
      @area[row_index][column_index].alive ? 1 : 0
    end
  end
end