require 'io/console'
require 'io/wait'
require './app/snake'
require './app/fruit'

class Game
  module Status
    RUN = 0
    GAME_OVER = 1
  end

  attr_accessor :size_x, :size_y, :status, :snake, :fruit

  def initialize(size_x, size_y)
    @size_x = size_x
    @size_y = size_y
  end

  def setup
    @snake = Snake.new(length: 3)
    snake.setup_coordinates(size_x, size_y)

    fruit_coordinates = new_fruit_coordinates
    @fruit = Fruit.new(fruit_coordinates[:x], fruit_coordinates[:y])

    @status = Status::RUN

    draw
  end

  def tick
    move
    draw
  end

  def input(input)
    return if input.nil?

    case input
    when 'w'
      snake.direction = Snake::Direction::UP
    when 's'
      snake.direction = Snake::Direction::DOWN
    when 'd'
      snake.direction = Snake::Direction::RIGHT
    when 'a'
      snake.direction = Snake::Direction::LEFT
    when "\u0003"
      puts 'ctrl-C'
      exit 0
    else
      puts "SOMETHING ELSE: #{input.inspect}"
    end
  end

  def draw_game_over
    system('clear') || system('cls')
    puts 'GAME OVER!'
    puts "Score: #{snake.length}"
    puts 'press R to play again'
  end

  private

  def move
    snake.move
    if snake.eat(fruit)
      eat
    elsif out_of_bounds? || collision?
      self.status = Status::GAME_OVER
    else
      snake.pop
    end
  end

  def eat
    snake.length += 1

    fruit_coordinates = new_fruit_coordinates
    fruit.coordinate_x = fruit_coordinates[:x]
    fruit.coordinate_y = fruit_coordinates[:y]
  end

  def out_of_bounds?
    return true if snake.coordinates_x[0] < 0 || snake.coordinates_x[0] >= size_x
    return true if snake.coordinates_y[0] < 0 || snake.coordinates_y[0] >= size_y

    false
  end

  def collision?
    (snake.length - 1).times do |index|
      if snake.coordinates_x[0] == snake.coordinates_x[index + 1] && snake.coordinates_y[0] == snake.coordinates_y[index + 1]
        return true
      end
    end

    false
  end

  def new_fruit_coordinates
    x = rand(size_x)
    y = rand(size_y)

    snake.length.times do |index|
      return new_fruit_coordinates if snake.coordinates_x[index] == x && snake.coordinates_y[index] == y
    end

    { x: x, y: y }
  end

  def draw
    system('clear') || system('cls')
    print_grid(size_x, size_y)
    pp snake.inspect
  end

  def print_grid(size_x, size_y)
    size_y.times do |y|
      size_x.times { print "+\u2014" }
      print "+\n"
      size_x.times { |x| print "|#{grid_box(x, y)}" }
      print "|\n"
    end

    print "+\u2014" * size_x, "+\n"
  end

  def grid_box(coordinate_x, coordinate_y)
    if snake.coordinates_x[0] == coordinate_x && snake.coordinates_y[0] == coordinate_y
      case snake.direction
      when Snake::Direction::UP then return "\u25B3"
      when Snake::Direction::DOWN then return "\u25BD"
      when Snake::Direction::RIGHT then return "\u25B7"
      when Snake::Direction::LEFT then return "\u25C1"
      end
    end

    snake.length.times do |body_index|
      if snake.coordinates_x[body_index] == coordinate_x && snake.coordinates_y[body_index] == coordinate_y
        return "\u25A1"
      end
    end

    return "\e[31m\uF8FF\e[0m" if fruit.coordinate_x == coordinate_x && fruit.coordinate_y == coordinate_y

    ' '
  end
end
