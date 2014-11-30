module GameOfLife
	class Game
		attr_reader :life_area
		def set_life_area(width, height)
			@life_area = create_empty_area(width, height)
		end

		def add_live_cell(line, column)
			if (is_in_life_area(line, column))
				raise CellIsOutsideOfLifeAreaError.new
			end
			@life_area[line][column] = 1
		end

		def evolve
			newGeneration = create_empty_area(@life_area[0].length, @life_area.length)

			@life_area.each_with_index { | row, rowIndex |
				row.each_with_index { | cell, columnIndex |
					if (cell_alive(cell))
						if (cell_dies(rowIndex, columnIndex))
							newGeneration[rowIndex][columnIndex] = 0
						else
							newGeneration[rowIndex][columnIndex] = 1
						end
					else
						if (cell_revives(rowIndex, columnIndex))
							newGeneration[rowIndex][columnIndex] = 1
						else
							newGeneration[rowIndex][columnIndex] = 0
						end
					end
				}
			}

			@life_area = newGeneration

			sleep 0.1
			print_area @life_area
		end

		private
		def create_empty_area(width, height)
			Array.new(height) { Array.new(width) { 0 } }
		end

		def is_in_life_area(line, column)
			return line >= @life_area.length ||	column >= @life_area[line].length
		end

		def cell_alive cell
			return cell != 0
		end

		def cell_dies(rowIndex, columnIndex)
			aliveNeighboursCount = alive_neighbours_count(rowIndex, columnIndex)
			return aliveNeighboursCount < 2 || aliveNeighboursCount > 3
		end

		def cell_revives(rowIndex, columnIndex)
			return alive_neighbours_count(rowIndex, columnIndex) == 3
		end

		def alive_neighbours_count(rowIndex, columnIndex)
			maxRowIndex = @life_area.length - 1
			maxColumnIndex = @life_area[0].length - 1
			aliveNeighboursCount = 0
			if rowIndex > 0
				if columnIndex > 0
					aliveNeighboursCount += count_aliveness(rowIndex - 1, columnIndex - 1)
				end
				aliveNeighboursCount += count_aliveness(rowIndex - 1, columnIndex)
				if (maxColumnIndex > columnIndex)
					aliveNeighboursCount += count_aliveness(rowIndex - 1, columnIndex + 1)
				end
			end

			if columnIndex > 0
				aliveNeighboursCount += count_aliveness(rowIndex, columnIndex - 1)
			end
			if maxColumnIndex > columnIndex
				aliveNeighboursCount += count_aliveness(rowIndex, columnIndex + 1)
			end

			if maxRowIndex > rowIndex
				if columnIndex > 0
					aliveNeighboursCount += count_aliveness(rowIndex + 1, columnIndex - 1)
				end
				aliveNeighboursCount += count_aliveness(rowIndex + 1, columnIndex)
				if (maxColumnIndex > columnIndex)
					aliveNeighboursCount += count_aliveness(rowIndex + 1, columnIndex + 1)
				end
			end

			return aliveNeighboursCount
		end

		def count_aliveness(rowIndex, columnIndex)
			return @life_area[rowIndex][columnIndex] == 0 ? 0 : 1
		end
	end
end

def print_area area
	system "clear"
	area.each { | row | puts row.join " " }
end

def setup_zero_generation game, zeroGeneration
	zeroGeneration.each { | point | game.add_live_cell(point[0], point[1]) }
end
=begin
game = GameOfLife::Game.new
game.set_life_area(30, 20)
setup_zero_generation(game, [[2, 0], [2, 1], [2, 2], [1, 2], [0, 1]])
print_area game.life_area
90.times {
	game.evolve
}
=end