def parse_generation(generation_raw)
  generation_raw.lines.each.with_object([]).with_index do |(line, result), row_index|
    line.strip.chars.each.with_index.map do |cell, column_index|
      result << [row_index, column_index] if cell == '0'
    end
  end
end

def setup_zero_generation(area, generation_raw)
  parse_generation(generation_raw).each do |point|
    area.mark_cell_as_alive(point[0], point[1])
  end
end

def parse_sample_file(file_name)
  File.read(File.join(File.dirname(__FILE__), file_name))
    .split("\n\n")
end

def perform_generation_change_test(width, height, file_name)
  area = GameOfLife::LifeArea.new(width, height)
  game = GameOfLife::Game.new(area)
  generations = parse_sample_file(file_name)
  setup_zero_generation(area, generations.pop)
  generations.each do |generation|
    game.evolve
    verify_generation(area, generation)
  end
end

def verify_generation(area, generation)
  alive_cells = parse_generation(generation)
  area.height.times do |row_index|
    area.width.times do |column_index|
      expect(area.cell_alive?(row_index, column_index))
        .to eq(should_cell_be_alive(alive_cells, row_index, column_index))
    end
  end
end


def should_cell_be_alive(alive_cells, row_index, column_index)
  alive_cells.find do |cell_address|
    cell_address[0] == row_index && cell_address[1] == column_index
  end.present?
end
