require "rspec"
require_relative "../Game"
require_relative "../life_area"
require_relative "./shared_functions"

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
        generations.each_with_index { |generation, generation_index|
            if generation_index == 0
                setup_zero_generation(@area, generation)
            else
                @game.evolve
                verify_generation generation
            end
        }
    end

    def verify_generation generation
        alive_cells = parse_generation(generation)
        @area.height.times do |row_index|
            @area.width.times do |column_index|
                expect(@area.is_cell_alive?(row_index, column_index)).to eq(should_cell_be_alive(alive_cells, row_index, column_index))
            end
        end
    end

    def should_cell_be_alive alive_cells, row_index, column_index
        return alive_cells.index { |cell_address|
                cell_address[0] == row_index && cell_address[1] == column_index
            } != nil
    end
end

RSpec.describe GameOfLife::Game do
    include_context "game with area of 6 x 6"

    it "does nothing with Block in the first generation" do
        generations = []
        generations << <<-eos
------
--00--
--00--
eos
        generations << <<-eos
------
--00--
--00--
eos
        perform_generation_change_test generations
    end

    it "does nothing with Beehive in the first generation" do
        generations = []
        generations << <<-eos
------
--00--
-0--0-
--00--
eos
        generations << <<-eos
------
--00--
-0--0-
--00--
eos
        perform_generation_change_test generations
    end

    it "oscillates with line of three dots (period 2)" do
        generations = []
        generations << <<-eos
------
------
-000--
eos
        generations << <<-eos
------
--0---
--0---
--0---
eos
        generations << <<-eos
------
------
-000--
eos
        generations << <<-eos
------
--0---
--0---
--0---
eos
        perform_generation_change_test generations
    end

    it "oscillates with Beacon (period 2)" do
        generations = []
        generations << <<-eos
------
-00---
-00---
---00-
---00-
eos
        generations << <<-eos
------
-00---
-0----
----0-
---00-
eos
        generations << <<-eos
------
-00---
-00---
---00-
---00-
eos
        generations << <<-eos
------
-00---
-0----
----0-
---00-
eos
        perform_generation_change_test generations
    end
end