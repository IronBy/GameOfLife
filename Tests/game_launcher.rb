require_relative "../Game"
require_relative "../LifeArea"
require_relative "./shared_functions"

def print_area area
    area.height.times { |rowIndex|
        area.width.times { |columnIndex|
            print "#{area.is_cell_alive?(rowIndex, columnIndex) ? '0' : ' '} "
        }
        puts
    }
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
--0----0-0----0----------------
--0----0-0----0----------------
--0----0-0----0----------------
-------------------------------
----000---000-----------------
eof


area = GameOfLife::LifeArea.new(50, 35)
game = GameOfLife::Game.new(area)
setup_zero_generation(area, zero_generation)

20.times do
    system "clear"
    print_area area
    game.evolve
    sleep 0.2
end