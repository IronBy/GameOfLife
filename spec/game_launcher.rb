require_relative "../Game"
require_relative "../life_area"

require_relative 'spec_helper'

def print_area(area)
  puts((0...area.height).map do |row_index|
    (0...area.width).map { |column_index| area.cell_alive?(row_index, column_index) ? '0' : ' ' }.join
  end.join("\n"))
end

zero_generation = <<-eof
  -------------------------------
  -------------------------------
  ----000---000------------------
  -------------------------------
  --0----0-0----0----------------
  --0----0-0----0----------------
  --0----0-0----0----------------
  ----000---000------------------
  -------------------------------
  ----000---000------------------
  --0----0-0---00----------------
  --0----0-0----0----------------
  --0----0-0----0----------------
  -------------------------------
  ----000---000------------------
eof


area = GameOfLife::LifeArea.new(50, 35)
game = GameOfLife::Game.new(area)
setup_zero_generation(area, zero_generation)

200.times do
  system "clear"
  print_area area
  game.evolve
  sleep 0.01
end