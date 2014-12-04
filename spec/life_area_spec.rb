require_relative 'spec_helper'
require_relative "../Game"

RSpec.shared_examples "empty area with specified size" do |width, height|
  let(:life_area) { GameOfLife::LifeArea.new(width, height) }
  it "creates new empty area with specified size [#{width}, #{height}]" do
    width.times do |row_index|
      height.times do |column_index|
        expect(life_area.cell_alive?(row_index, column_index)).to be false
      end
    end
  end
end

RSpec.shared_examples "wrong area size" do |width, height|
  it "raises error when width is 0 or less on [#{width}, #{height}]" do
    expect { GameOfLife::LifeArea.new(width, height) }.to raise_error(GameOfLife::InvalidLifeAreaSizeError)
  end
end

RSpec.describe GameOfLife::LifeArea do
  describe "#initialize" do
    it "sets internal fields of width and height" do
      GameOfLife::LifeArea.new(width = 3, height = 2).tap do |life_area|
        expect([life_area.width, life_area.height]).to eq([width, height])
      end
    end

    [[-1, 1], [0, 1], [1, -1], [1, 0]].each do |width, height|
      it_behaves_like("wrong area size", width, height)
    end

    [[3, 5], [5, 2]].each do |width, height|
      it_behaves_like("empty area with specified size", width, height)
    end
  end
end

RSpec.shared_examples "cell outside of life area" do |row_index, column_index|
  it "raises error when cell [#{row_index}, #{column_index}] is outside of life area" do
    expect { life_area.mark_cell_as_alive(row_index, column_index) }.to raise_error(GameOfLife::CellIsOutsideOfLifeAreaError)
  end
end

RSpec.describe GameOfLife::LifeArea do
  let(:life_area) { GameOfLife::LifeArea.new(6, 6) }

  describe "#mark_cell_as_alive" do
    [[1, 6], [6, 1], [-1, 1], [1, -1]].each do |width, height|
      it_behaves_like("cell outside of life area", width, height)
    end
  end
end

RSpec.shared_context "of area with size 6 x 6 and alive square of size 3 x 3" do
  let(:life_area) { GameOfLife::LifeArea.new(6, 6) }

  before do
    setup_zero_generation(life_area, <<-eof)
      000
      000
      000
    eof
  end
end

RSpec.shared_examples "alive neighbours counting" do |row_index, column_index, neighbours|
  it "returns count of alive neighbour cells" do
    expect(life_area.get_alive_neighbours_count(row_index, column_index)).to eq(neighbours)
  end
end

RSpec.describe GameOfLife::LifeArea do
  include_context "of area with size 6 x 6 and alive square of size 3 x 3"

  describe "#get_alive_neighbours_count" do
    [[1, 1, 8], [0, 0, 3], [0, 1, 5], [3, 3, 1]].each do |row, column, neighbours|
      it_behaves_like("alive neighbours counting", row, column, neighbours)
    end
  end
end
