#!/bin/env ruby
require 'rubygems'
require 'gosu'

WIN_WIDTH = 800     # Window width
WIN_HEIGHT = 600    # Window height
CELL_SIZE = 10       # Size of cell square
CELL_COLOR = Gosu::Color.new(0xff00ffff)
EMPTY_COLOR = Gosu::Color.new(0x00000000)

class NanoWindow < Gosu::Window
    def initialize
        super WIN_WIDTH, WIN_HEIGHT, false
        self.caption = 'Nano Game of Life'

        # Create a game of life grid
        @grid = LifeGrid.new(self)
    end

    def needs_cursor?; true; end

    def update
        @grid.update
    end

    def draw
        @grid.draw
    end

end

class LifeGrid
    def initialize(window)
        @num_cols = WIN_WIDTH / CELL_SIZE
        @num_rows = WIN_HEIGHT / CELL_SIZE
        @grid = Array.new(@num_cols) {Array.new(@num_rows, 0)}
        @window = window
        self.randomize
    end

    def randomize
        (0...@num_cols).each do |x|
            (0...@num_rows).each do |y|
                @grid[x][y] = rand(2)
            end
        end

    end

    def update
        # for all cells
            # num_neighbors = check neighbors(x,y)
            # depending on number of neighbors
                # change state to alive or dead

    end

    def check_neighbors
        # check_neighbors
        # update state
    end


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

end


window = NanoWindow.new
window.show
