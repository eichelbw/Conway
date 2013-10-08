require 'rspec'
require "pry"

class Cell
  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
  end
end

class World

  def initialize(list_of_cells)
    @list_of_cells = list_of_cells
  end

  def list_of_cells
    @list_of_cells
  end

  def neighbors(test_cell)
    neighbors_list = []
    x_coord = test_cell.coordinates.first
    y_coord = test_cell.coordinates.last
    self.list_of_cells.each do |cell|
      (x_coord - 1...x_coord + 1).each do |x|
        (y_coord - 1...y_coord + 1).each do |y|
          coordinates_logic(x, y, cell, test_cell, neighbors_list)
        end
      end
    end
    neighbors_list
  end

  def coordinates_logic(x, y, cell, test_cell, neighbors_list)
    if [x, y] == cell.coordinates && [x, y] != test_cell.coordinates
      neighbors_list << cell
    end
  end

  def number_of_neighbors(test_cell)
    self.neighbors(test_cell).length    
  end

  def is_alive?(coordinates)
    x_coord = coordinates.first
    y_coord = coordinates.last
    self.list_of_cells.each do |cell|
      if [x_coord,y_coord] == cell.coordinates
        true
      else
        false
      end
    end
  end

  def rules()
    binding.pry
    self.list_of_cells.each do |cell|
      binding.pry
      # Rule 1    
      if self.number_of_neighbors(cell) < 2
        self.list_of_cells.delete(cell)
        binding.pry
      end
    end
    self.list_of_cells
  end
end

describe 'the game of life' do 

  describe 'class initiialization' do
  
    it 'cell should initialize with coordinate information' do
      cell = Cell.new([1, 1])

      cell.should be_an_instance_of(Cell)
    end

    it 'world should initialize with a list of cells' do
      cell = Cell.new([1, 1])
      world = World.new([cell])  

      world.should be_an_instance_of(World)
    end
  end

  describe 'cell methods' do

    it '#coordinates should return the cell coordinates' do
      cell = Cell.new([1, 1])

      cell.coordinates.should eq [1, 1]
    end

    it '#number_of_neighbors(test_cell) should return the number of neighbors' do
      test_cell = Cell.new([1, 1])
      cell_1 = Cell.new([0, 1])
      cell_2 = Cell.new([1, 0])
      world_1 = World.new([test_cell,cell_1])
      world_2 = World.new([test_cell,cell_1,cell_2])

      world_1.number_of_neighbors(test_cell).should eq 1
      world_2.number_of_neighbors(test_cell).should eq 2
    end
  end

  describe 'world methods' do

    it '#list_of_cells should return a list of the cells in the world' do
      cell_1 = Cell.new([1,1])
      cell_2 = Cell.new([1,1])
      world = World.new([cell_1,cell_2])

      world.list_of_cells.should include(cell_1)
      world.list_of_cells.should be_an_instance_of(Array)
    end

    it '#neighbors(test_cell) should return a list of cells neighboring test_cell' do
      test_cell = Cell.new([1,1])
      cell_1 = Cell.new([0,1])
      cell_2 = Cell.new([1,0])
      world = World.new([test_cell,cell_1,cell_2])

      world.neighbors(test_cell).should include(cell_1, cell_2)
    end

    it '#neighbors(test_cell) should not return itself' do
      test_cell = Cell.new([1,1])
      cell_1 = Cell.new([0,1])
      cell_2 = Cell.new([1,0])
      world = World.new([test_cell,cell_1,cell_2])   
      
      world.neighbors(test_cell).should_not include(test_cell)
    end

    it '#is_alive?(coordinates) should return true if a cell exists at coordinates' do
      cell_1 = Cell.new([1,1])
      cell_2 = Cell.new([1,0])
      world = World.new([cell_1,cell_2])

      world.is_alive?([1,1]).should be_true
    end 

    describe 'the rules of the game' do

      it 'Rule 1: if a cell has less than two neighbors, it dies' do
        test_cell = Cell.new([1,1])
        cell_1 = Cell.new([1,0])
        world_1 = World.new([test_cell])
        world_2 = World.new([test_cell,cell_1])

        world_1.rules().should_not include(test_cell)
        world_2.rules().should_not include(test_cell)
        world_2.rules().should_not include(cell_1)
      end

      it 'Rule 2a: if a live cell has two or three neighbors, it lives' do
        test_cell = Cell.new([1,1])
        cell_1 = Cell.new([1,0])
        cell_2 = Cell.new([0,1])
        cell_3 = Cell.new([1,3])
        world_1 = World.new([test_cell,cell_1,cell_2])
        world_2 = World.new([test_cell,cell_1,cell_2,cell_3])

        # world_1.rules().should include(test_cell,cell_1,cell_2)
        # world_2.rules().should include(test_cell,cell_1,cell_2)
        # world_2.rules().should_not include(cell_3)
      end
    end
  end
end
