class Snake
  module Direction
    UP = 0
    DOWN = 1
    LEFT = 2
    RIGHT = 3
  end

  attr_accessor :length, :direction, :coordinates_x, :coordinates_y

  def initialize(length:)
    @length = length
    @direction = Direction::UP
    @coordinates_x = []
    @coordinates_y = []
  end

  def setup_coordinates(grid_size_x, grid_size_y)
    coordinates_x << (grid_size_x / 2.0).ceil
    coordinates_y << (grid_size_y / 2.0).ceil

    (length - 1).times do
      coordinates_x << coordinates_x.last
      coordinates_y << (coordinates_y.last + 1)
    end
  end

  def move
    if direction == Direction::UP
      move_up
    elsif direction == Direction::DOWN
      move_down
    elsif direction == Direction::LEFT
      move_left
    elsif direction == Direction::RIGHT
      move_right
    end
  end

  def pop
    coordinates_x.pop
    coordinates_y.pop
  end

  def eat(fruit)
    return true if coordinates_x[0] == fruit.coordinate_x && coordinates_y[0] == fruit.coordinate_y

    false
  end

  private

  def move_up
    coordinates_x.unshift(coordinates_x.first)
    coordinates_y.unshift(coordinates_y.first - 1)
  end

  def move_down
    coordinates_x.unshift(coordinates_x.first)
    coordinates_y.unshift(coordinates_y.first + 1)
  end

  def move_left
    coordinates_x.unshift(coordinates_x.first - 1)
    coordinates_y.unshift(coordinates_y.first)
  end

  def move_right
    coordinates_x.unshift(coordinates_x.first + 1)
    coordinates_y.unshift(coordinates_y.first)
  end
end
