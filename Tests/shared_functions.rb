def parse_generation generation_raw
  alive_cells = []
  lines = generation_raw.lines.each_with_index { |line, row_index|
    line.chars.each_with_index { |cell, column_index|
    alive_cells << [row_index, column_index] if cell == '0' }
  }

  return alive_cells
end

def setup_zero_generation(area, generation_raw)
  parse_generation(generation_raw).
    each { |point|
      area.mark_cell_as_alive(point[0], point[1])
    }
end