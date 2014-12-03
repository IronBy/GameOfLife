module GameOfLife
    class Game
        attr_reader :area

        def initialize(area)
            raise ArgumentError.new if area == nil
            @area = area
        end

        def evolve
            @area.height.times { |row_index|
                @area.width.times { |column_index|
                    if (@area.is_cell_alive?(row_index, column_index))
                        if (cell_dies?(row_index, column_index))
                            @area.mark_dead_in_next_generation(row_index, column_index)
                        else
                            @area.mark_alive_in_next_generation(row_index, column_index)
                        end
                    else
                        if (cell_revives?(row_index, column_index))
                            @area.mark_alive_in_next_generation(row_index, column_index)
                        else
                            @area.mark_dead_in_next_generation(row_index, column_index)
                        end
                    end
                }
            }

            @area.upgrade_generation
        end

        private
        def create_empty_area(width, height)
            Array.new(height) { Array.new(width) { 0 } }
        end

        def cell_dies?(row_index, column_index)
            alive_neighbours_count = @area.get_alive_neighbours_count(row_index, column_index)
            return alive_neighbours_count < 2 || alive_neighbours_count > 3
        end

        def cell_revives?(row_index, column_index)
            return @area.get_alive_neighbours_count(row_index, column_index) == 3
        end
    end
end