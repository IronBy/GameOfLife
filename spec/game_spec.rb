require_relative "spec_helper"
require_relative "../Game"

RSpec.describe GameOfLife::Game do
  describe "#initialize" do
    it "raises error if life area is nil" do
      expect { GameOfLife::Game.new(nil) }.to raise_exception(ArgumentError)
    end
  end
end

RSpec.describe GameOfLife::Game do
  let(:file_name) { "" }

  after { perform_generation_change_test(6, 6, file_name) }

  it "does nothing with Block in the first generation" do
    file_name << "block_sample.txt"
  end

  it "does nothing with Beehive in the first generation" do
    file_name << "beehive_sample.txt"
  end

  it "oscillates with line of three dots (period 2)" do
    file_name << "three_cells_line_sample.txt"
  end

  it "oscillates with Beacon (period 2)" do
    file_name << "beacon_sample.txt"
  end
end
