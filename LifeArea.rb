require_relative "./InvalidLifeAreaSizeError"
require_relative "./CellIsOutsideOfLifeAreaError"
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

        def mark_cell_as_alive(rowIndex, columnIndex)
            verify_is_in_life_area?(rowIndex, columnIndex)
            @area[rowIndex][columnIndex].is_alive = true
        end

        def is_cell_alive?(rowIndex, columnIndex)
            return is_in_life_area?(rowIndex, columnIndex) &&
                @area[rowIndex][columnIndex].is_alive
        end

        def get_alive_neighbours_count(rowIndex, columnIndex)
            return count_aliveness(rowIndex - 1, columnIndex - 1) +
                count_aliveness(rowIndex - 1, columnIndex) +
                count_aliveness(rowIndex - 1, columnIndex + 1) +
                count_aliveness(rowIndex , columnIndex - 1) +
                count_aliveness(rowIndex, columnIndex + 1) +
                count_aliveness(rowIndex + 1, columnIndex - 1) +
                count_aliveness(rowIndex + 1, columnIndex) +
                count_aliveness(rowIndex + 1, columnIndex + 1)
        end

        def mark_dead_in_next_generation(rowIndex, columnIndex)
            @area[rowIndex][columnIndex].is_alive_in_next_generation = false
        end

        def mark_alive_in_next_generation(rowIndex, columnIndex)
            @area[rowIndex][columnIndex].is_alive_in_next_generation = true
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

        def verify_is_in_life_area?(rowIndex, columnIndex)
            raise CellIsOutsideOfLifeAreaError.new if !is_in_life_area?(rowIndex, columnIndex)
        end

        def is_in_life_area?(rowIndex, columnIndex)
            return rowIndex >= 0 && rowIndex < @height &&
                columnIndex >= 0 && columnIndex < @width
        end

        def create_empty_area(width, height)
            Array.new(height) { Array.new(width) { Cell.new } }
        end

        def count_aliveness(rowIndex, columnIndex)
            return 0 if !is_in_life_area?(rowIndex, columnIndex)
            return @area[rowIndex][columnIndex].is_alive ? 1 : 0
        end
    end
end