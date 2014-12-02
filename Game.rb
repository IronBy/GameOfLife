module GameOfLife
    class Game
        attr_reader :life_area
        attr_reader :area

        def initialize(area)
            raise ArgumentError.new if area == nil
            @area = area
        end

        def evolve
            @area.height.times { |rowIndex|
                @area.width.times { |columnIndex|
                    if (@area.is_cell_alive?(rowIndex, columnIndex))
                        if (cell_dies?(rowIndex, columnIndex))
                            @area.mark_dead_in_next_generation(rowIndex, columnIndex)
                        else
                            @area.mark_alive_in_next_generation(rowIndex, columnIndex)
                        end
                    else
                        if (cell_revives?(rowIndex, columnIndex))
                            @area.mark_alive_in_next_generation(rowIndex, columnIndex)
                        else
                            @area.mark_dead_in_next_generation(rowIndex, columnIndex)
                        end
                    end
                }
            }

            @area.upgrade_generation

            #print_area @area
        end

        private
        def create_empty_area(width, height)
            Array.new(height) { Array.new(width) { 0 } }
        end

        def cell_dies?(rowIndex, columnIndex)
            aliveNeighboursCount = @area.get_alive_neighbours_count(rowIndex, columnIndex)
            return aliveNeighboursCount < 2 || aliveNeighboursCount > 3
        end

        def cell_revives?(rowIndex, columnIndex)
            return @area.get_alive_neighbours_count(rowIndex, columnIndex) == 3
        end
    end
end

def print_area area
    sleep 0.3
    system "clear"
    @area.height.times { |rowIndex|
        @area.width.times { |columnIndex|
            print "#{@area.is_cell_alive?(rowIndex, columnIndex) ? 1 : 0} "
        }
        puts
    }
end