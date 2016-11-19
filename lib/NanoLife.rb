#!/bin/env ruby
require 'rubygems'
require 'gosu'

WIN_WIDTH = 1024   # Window width
WIN_HEIGHT = 768  # Window height
CELL_SIZE = 8     # Size of cell square
CELL_COLOR = Gosu::Color.new(0xff00ffff)
EMPTY_COLOR = Gosu::Color.new(0x00000000)
MAX_FPS = 30    # For calculating max framerate

# Keybinds:
# s - Start and stop (pause) the game
# c - Clear the grid
# r - Randomize the grid
# Left Click - Invert the state of the cell clicked
# q/Esc - Quit

class LifeGameWindow < Gosu::Window
  # Game of Life window/screen manager

  # Initialize Gosu window and LifeGrid
  def initialize
    # Gosu window
    super WIN_WIDTH, WIN_HEIGHT, false, 1000.0 / MAX_FPS
    self.caption = 'NanoLife - Conway\'s Game of Life'
    # Create a game of life grid and start randomly
    @grid = LifeGrid.new(self)
    @grid.randomize
    # Set running to true. Game can be paused with keyboard
    @running = true
  end

  # Turn on cursor
  def needs_cursor?; true; end

  # Update everything each frame before drawing
  def update
    if @running # and delta is met
      @grid.update
    end
  end

  # Draw screen
  def draw
    @grid.draw
  end

  # Override callback for a button pressed
  def button_down(id)
    if id == Gosu::KbEscape or id  == Gosu::KbQ
      close
    elsif id == Gosu::KbS
      @running = !@running
    elsif id == Gosu::KbC
      @grid.clear
    elsif id == Gosu::KbR
        @grid.randomize
    elsif id == Gosu::MsLeft
      @grid.invert_cell(
        mouse_x.to_i / CELL_SIZE,
        mouse_y.to_i / CELL_SIZE
      )
    end
  end
end

class LifeGrid
  # Manages the underlying array of cells and their life process

  def initialize(window)
    @num_cols = WIN_WIDTH / CELL_SIZE
    @num_rows = WIN_HEIGHT / CELL_SIZE
    @grid = create_grid
    @window = window
  end

  # Create an empty grid array
  def create_grid
    return Array.new(@num_cols) {Array.new(@num_rows, 0)}
  end

  # Ipdate state of all cells based on Conway's Game of Life rules
  def update
    # For all cells check neighbors and kill or birth
    tmp_grid = create_grid
    (0...@num_cols).each do |x|
      (0...@num_rows).each do |y|
        num_neighbors = check_neighbors(x, y)

        if num_neighbors < 2 and @grid[x][y] == 1
          tmp_grid[x][y] = 0
        end
        if num_neighbors == 2 or num_neighbors == 3
          if @grid[x][y] == 1
            tmp_grid[x][y] = 1
          end
        end
        if num_neighbors == 3 and @grid[x][y] == 0
          tmp_grid[x][y] = 1
        end
        if num_neighbors > 3 and @grid[x][y] == 1
          tmp_grid[x][y] = 0
        end
      end
    end
    @grid = tmp_grid
  end

  # Given an x and y, calculate how many neighbors cell has
  def check_neighbors(x, y)
    num_neighbors = 0

    # Previous row
    if y > 0 and x > 0
      num_neighbors += @grid[x-1][y-1]
    end
    if y > 0
      num_neighbors += @grid[x][y-1]
    end
    if x < @num_cols - 1 and y > 0
      num_neighbors += @grid[x+1][y-1]
    end

    # Current row
    if x > 0
      num_neighbors += @grid[x-1][y]
    end
    if x < @num_cols - 1
      num_neighbors += @grid[x+1][y]
    end

    # Lower row
    if x > 0 and y < @num_rows - 1
      num_neighbors += @grid[x-1][y+1]
    end
    if y < @num_rows - 1
      num_neighbors += @grid[x][y+1]
    end
    if x < @num_cols - 1 and y < @num_rows - 1
      num_neighbors += @grid[x+1][y+1]
    end

    return num_neighbors
  end

  # Draw the cell grid to the window
  def draw
    # draw grid
    (0...@num_cols).each do |x|
      (0...@num_rows).each do |y|
        if @grid[x][y] == 0
          color = EMPTY_COLOR
        else
          color = CELL_COLOR
        end
        realx = x * CELL_SIZE
        realy = y * CELL_SIZE
        @window.draw_quad(
          realx, realy, color,
          realx + CELL_SIZE, realy, color,
          realx, realy + CELL_SIZE, color,
          realx + CELL_SIZE, realy + CELL_SIZE, color,
        )
      end
    end
  end

  # Flip the state of a cell. Useful for manual click manipulation
  def invert_cell(x, y)
    @grid[x][y] = (@grid[x][y] == 0 ? 1 : 0)
  end

  # Utility function to randomize grid
  def randomize
    (0...@num_cols).each do |x|
      (0...@num_rows).each do |y|
        @grid[x][y] = rand(2)
      end
    end
  end

  # Utility function to randomize grid
  def clear
    (0...@num_cols).each do |x|
      (0...@num_rows).each do |y|
        @grid[x][y] = 0
      end
    end
  end

end

