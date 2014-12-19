require_relative "spec_helper"
require_relative "../Game"

def parse_sample_file(file_name, generations)
  generations_added = 0
  File.open(File.join(File.dirname(__FILE__), file_name)) do |file|
    generations << ""
    file.each() do |line|
      if (line.chomp.length > 0)
        generations[generations.length - 1] += line
      else
        generations << ""
      end
    end
  end
end

RSpec.describe GameOfLife::Game do
  describe "#initialize" do
    it "raises error if life area is nil" do
      expect { GameOfLife::Game.new(nil) }.to raise_exception(ArgumentError)
    end
  end
end

RSpec.describe GameOfLife::Game do
  let(:area) { GameOfLife::LifeArea.new(6, 6) }
  let(:game) { GameOfLife::Game.new(area) }
  let(:generations) { [] }

  after { perform_generation_change_test(game, area, generations) }

  it "does nothing with Block in the first generation" do
    parse_sample_file("block_sample.txt", generations)
  end

  it "does nothing with Beehive in the first generation" do
    parse_sample_file("beehive_sample.txt", generations)
  end

  it "oscillates with line of three dots (period 2)" do
    parse_sample_file("three_cells_line_sample.txt", generations)
  end

  it "oscillates with Beacon (period 2)" do
    parse_sample_file("beacon_sample.txt", generations)
  end
end
