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
  {
    "block_sample.txt" => "does nothing with Block in the first generation",
    "beehive_sample.txt" => "does nothing with Beehive in the first generation",
    "three_cells_line_sample.txt" => "oscillates with line of three dots (period 2)",
    "beacon_sample.txt" => "oscillates with Beacon (period 2)"
  }.each do |file_name, message|
    it message do
      perform_generation_change_test(6, 6, file_name)
    end
  end
end
