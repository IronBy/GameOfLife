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
  let(:area) { GameOfLife::LifeArea.new(6, 6) }
  let(:game) { GameOfLife::Game.new(area) }

  let(:generations) { [] }
  after { perform_generation_change_test game, area, generations }

  it "does nothing with Block in the first generation" do
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
  end

  it "does nothing with Beehive in the first generation" do
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
  end

  it "oscillates with line of three dots (period 2)" do
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
  end

  it "oscillates with Beacon (period 2)" do
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
  end
end
