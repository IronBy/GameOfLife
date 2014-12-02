require "rspec"
require_relative "../LifeArea"

RSpec.shared_examples "empty area with specified size" do |width, height|
    it "creates new empty area with specified size" do
        lifeArea = GameOfLife::LifeArea.new(width, height)
        
        width.times do | rowIndex |
            height.times do | columnIndex |
                expect(lifeArea.is_cell_alive?(rowIndex, columnIndex)).to be_falsy
            end
        end
    end
end

RSpec.shared_examples "wrong area size" do |width, height|
    it "raises error when width is 0 or less" do
        expect { GameOfLife::LifeArea.new(width, height) }.to raise_error(InvalidLifeAreaSizeError)
    end
end

RSpec.describe GameOfLife::LifeArea do
    describe "#initialize" do
        it "sets internal fields of width and height" do
            width = 3
            height = 2
            
            lifeArea = GameOfLife::LifeArea.new(width, height)
            
            expect(lifeArea.width).to eq(width)
            expect(lifeArea.height).to eq(height)
        end

        include_examples("wrong area size", -1, 1)
        include_examples("wrong area size", 0, 1)
        include_examples("wrong area size", 1, -1)
        include_examples("wrong area size", 1, 0)

        include_examples("empty area with specified size", 3, 5)
        include_examples("empty area with specified size", 5, 2)
    end
end

RSpec.shared_context "of empty area with size 6 x 6" do
    before {
        @lifeArea = GameOfLife::LifeArea.new(6, 6)
    }
end

RSpec.shared_examples "cell outside of life area" do |rowIndex, columnIndex|
    it "raises error when cell is outside of life area" do
        expect { @lifeArea.mark_cell_as_alive(rowIndex, columnIndex) }.to raise_error(CellIsOutsideOfLifeAreaError)
    end
end

RSpec.describe GameOfLife::LifeArea do
    include_context "of empty area with size 6 x 6"

    describe "#mark_cell_as_alive" do
        include_examples("cell outside of life area", 1, 6)
        include_examples("cell outside of life area", 6, 1)
        include_examples("cell outside of life area", -1, 1)
        include_examples("cell outside of life area", 1, -1)
    end

    describe "#is_cell_alive?" do
        it "returns true for alive cells otherwise false" do
            rowIndex = 1
            columnIndex = 2

            @lifeArea.mark_cell_as_alive(rowIndex, columnIndex)
            
            expect(@lifeArea.is_cell_alive?(rowIndex, columnIndex)).to be_truthy
        end
    end
end

RSpec.shared_context "of area with size 6 x 6 and alive square of size 3 x 3" do
    include_context "of empty area with size 6 x 6"

    before {
        @lifeArea.mark_cell_as_alive(0, 0)
        @lifeArea.mark_cell_as_alive(0, 1)
        @lifeArea.mark_cell_as_alive(0, 2)
        @lifeArea.mark_cell_as_alive(1, 0)
        @lifeArea.mark_cell_as_alive(1, 1)
        @lifeArea.mark_cell_as_alive(1, 2)
        @lifeArea.mark_cell_as_alive(2, 0)
        @lifeArea.mark_cell_as_alive(2, 1)
        @lifeArea.mark_cell_as_alive(2, 2)
    }
end

RSpec.shared_examples "alive neighbours counting" do | rowIndex, columnIndex, expectedNeighboursCount |
    it "returns count of alive neighbour cells" do
        expect(@lifeArea.get_alive_neighbours_count(rowIndex, columnIndex)).to eq(expectedNeighboursCount)
    end
end

RSpec.describe GameOfLife::LifeArea do
    include_context "of area with size 6 x 6 and alive square of size 3 x 3"

    describe "#get_alive_neighbours_count" do
        include_examples("alive neighbours counting", 1, 1, 8)
        include_examples("alive neighbours counting", 0, 0, 3)
        include_examples("alive neighbours counting", 0, 1, 5)
        include_examples("alive neighbours counting", 3, 3, 1)
    end

    describe "#upgrade_generation" do
        area = GameOfLife::LifeArea.new(2, 1)
        area.mark_cell_as_alive(0, 0)
        area.mark_dead_in_next_generation(0, 0)
        area.mark_alive_in_next_generation(0, 1)

        area.upgrade_generation

        it "allows to mark cell as dead in next generation" do
            expect(area.is_cell_alive?(0, 0)).to be false
        end

        it "allows to mark cell as alive in next generation" do
            expect(area.is_cell_alive?(0, 1)).to be true
        end
    end
end