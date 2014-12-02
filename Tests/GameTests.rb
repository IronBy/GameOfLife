require "rspec"
require_relative "../Game"
require_relative "../LifeArea"

RSpec.describe GameOfLife::Game do
    describe "#initialize" do
        it "raises error if life area is nil" do
            expect { GameOfLife::Game.new(nil) }.to raise_exception(ArgumentError)
        end

        it "initializes area" do
            area = GameOfLife::LifeArea.new(6, 6)
            game = GameOfLife::Game.new(area)

            expect(game.area).to be(area)
        end
    end
end

RSpec.shared_context "game with area of 6 x 6" do
    before {
        @area = GameOfLife::LifeArea.new(6, 6)
        @game = GameOfLife::Game.new(@area)
    }

    def perform_generation_change_test generations
        generations.each_with_index { | aliveCells, generationIndex |
            if generationIndex == 0
                setup_zero_generation generations[0]
                #print_area @area
            else
                @game.evolve
                verify_generation aliveCells
            end
        }
    end

    def setup_zero_generation zeroGeneration
        zeroGeneration.each { | point | add_alive_cell(point[0], point[1]) }
    end

    def add_alive_cell(line, column)
        @area.mark_cell_as_alive(line, column)
    end

    def verify_generation aliveCells
        @area.height.times do | rowIndex |
            @area.width.times do | columnIndex |
                expect(@area.is_cell_alive?(rowIndex, columnIndex)).to eq(should_cell_be_alive(aliveCells, rowIndex, columnIndex))
            end
        end
    end

    def should_cell_be_alive aliveCells, rowIndex, columnIndex
        return aliveCells.index { | cellAddress |
            cellAddress[0] == rowIndex && cellAddress[1] == columnIndex} != nil
    end
end

RSpec.describe GameOfLife::Game do
    include_context "game with area of 6 x 6"

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