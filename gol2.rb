require 'rspec'
require "pry"


class World < Array
  attr_accessor :dimensions

  def initialize(dimensions,seed_probabily)
    @dimensions = dimensions
    @cells = Array.new(@dimensions[0]) {
     Array.new(@dimensions[1]) { 
      Cell.new(seed_probabily) } 
    }
  end

  def [](value)
    super
  end

  def []=(value)
    super
  end
end

class Cell

  def initialize(seed_probabily)
    @alive = seed_probabily < rand
  end
end

describe 'the game of life' do 

  describe 'class initialization' do

    it 'world initialization should take dimensions, seed probability and return an array' do
      world = World.new([10,10],0.5)

      world.should be_an_instance_of(World)
    end

    it 'cell initialization should take seed probability' do
      cell = Cell.new(0.5)

      cell.should be_an_instance_of(Cell)
    end
  end

  describe 'world methods' do

    it '#alive_neighbors(coordinates) should return number of live neighbors to cell at coordinates' do
      world = World.new([5,5],0.5)
      world[1][1] = 1
      world.alive_neighbors([1,1]).should eq 0
      world[1][0] = 1
      world.alive_neighbors([1,1]).should eq 1
      world[0][1] = 1
      world.alive_neighbors([1,1]).should eq 2
    end
  end
end