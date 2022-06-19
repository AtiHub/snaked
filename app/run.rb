require './app/game'
require './app/key'

ticks = 1.5
interval = 1_000.0 / ticks

size_x = 16
size_y = 8

running = true
game = Game.new(size_x, size_y)
game.setup

while running
  game_over_input(game) while game.status == Game::Status::GAME_OVER

  input = run_input(interval)

  game.input(input)
  game.tick
end
