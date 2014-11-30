require "rspec"
require "../Game"
require "../CellIsOutsideOfLifeAreaError"

def expect_is_array_of_length row, length
	expect(row).to be_an_instance_of(Array)
	expect(row.length).to eq(length)
end

def expect_is_empty_array_of_length row, length
	expect_is_array_of_length(row, length)
	row.each do | item |
		expect(item).to be(0)
	end
end

RSpec.shared_examples "empty area with specified size" do |width, height|
	it "creates new empty area with specified size" do
		game = GameOfLife::Game.new
		game.set_life_area(width, height)
		
		expect_is_array_of_length(game.life_area, height)
		game.life_area.each do | row |
			expect_is_empty_array_of_length(row, width)
		end
	end
end

RSpec.shared_context "game with area of 6 x 6" do
	before {
		@game = GameOfLife::Game.new
		@game.set_life_area(6, 6)
	}

	def add_live_cell(line, column)
		@game.add_live_cell(line, column)
	end

	def sets_live_cell(line, column)
		@game.add_live_cell(line, column)
		return @game.life_area[line][column] == 1
	end

	def perform_generation_change_test generations
		generations.each_with_index { | aliveCells, generationIndex |
			if generationIndex == 0
				setup_zero_generation generations[0]
				print_area @game.life_area
			else
				@game.evolve
				verify_generation aliveCells
			end
		}
	end

	def setup_zero_generation zeroGeneration
		zeroGeneration.each { | point | add_live_cell(point[0], point[1]) }
	end

	def verify_generation aliveCells
		@game.life_area.each_with_index { | row, rowIndex |
			row.each_with_index { | cell, columnIndex |
				isCellAlive = cell == 1
				expect(isCellAlive).to eq(should_cell_be_alive(aliveCells, rowIndex, columnIndex))
			}
		}
	end

	def should_cell_be_alive aliveCells, rowIndex, columnIndex
		return aliveCells.index { | cellAddress |
			cellAddress[0] == rowIndex && cellAddress[1] == columnIndex} != nil
	end

	def expect_life_area_size width, height
		expect(@game.life_area.length).to be(height)
		expect(@game.life_area[0].length).to be(width)
	end
end

RSpec.describe GameOfLife::Game do
	include_context "game with area of 6 x 6"

	describe "#set_life_area" do
		include_examples "empty area with specified size", 3, 5
		include_examples "empty area with specified size", 5, 3
	end

	it "throws exception if cell is outside of life area" do
		expect { add_live_cell(1, 6) }.to raise_error(CellIsOutsideOfLifeAreaError)
		expect { add_live_cell(6, 1) }.to raise_error(CellIsOutsideOfLifeAreaError)
	end

	it "sets live cell correctly" do
		expect(sets_live_cell(2, 3)).to be_truthy
		expect(sets_live_cell(1, 4)).to be_truthy
	end

	it "does not change life area size at evolution time" do
		areaWidth = 7
		areaHeight = 17
		@game.set_life_area(areaWidth, areaHeight)

		expect_life_area_size(areaWidth, areaHeight)
		@game.evolve
		expect_life_area_size(areaWidth, areaHeight)
	end

	it "does nothing with Block in the first generation" do
		perform_generation_change_test [
			[[1, 1], [1, 2], [2, 1], [2, 2]],
			[[1, 1], [1, 2], [2, 1], [2, 2]]
		]
	end

	it "does nothing with Beehive in the first generation" do
		perform_generation_change_test [
			[[2, 1], [1, 2], [1, 3], [2, 4], [3, 2], [3, 3]],
			[[2, 1], [1, 2], [1, 3], [2, 4], [3, 2], [3, 3]]
		]
	end

	it "oscillates with line of three dots (period 2)" do
		perform_generation_change_test [
			[[2, 2], [2, 3], [2, 4]],
			[[1, 3], [2, 3], [3, 3]],
			[[2, 2], [2, 3], [2, 4]],
			[[1, 3], [2, 3], [3, 3]]
		]
	end

	it "oscillates with Beacon (period 2)" do
		perform_generation_change_test [
			[[1, 1], [1, 2], [2, 1], [2, 2], [3, 3], [3, 4], [4, 3], [4, 4]],
			[[1, 1], [1, 2], [2, 1], [3, 4], [4, 3], [4, 4]],
			[[1, 1], [1, 2], [2, 1], [2, 2], [3, 3], [3, 4], [4, 3], [4, 4]],
			[[1, 1], [1, 2], [2, 1], [3, 4], [4, 3], [4, 4]]
		]
	end
end