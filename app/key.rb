require 'timeout'

def run_input(interval)
  $stdin.echo = false
  $stdin.raw!
  Timeout::timeout(interval / 1000) { $stdin.getch }
rescue Timeout::Error
  nil
ensure
  $stdin.echo = true
  $stdin.cooked!
end

def game_over_input(game)
  game.draw_game_over

  $stdin.echo = false
  $stdin.raw!
  input = $stdin.getch

  $stdin.echo = true
  $stdin.cooked!

  if input == "\u0003"
    puts 'ctrl-C'
    exit 0
  elsif input == 'r'
    game.setup
    game.status = Game::Status::RUN
  end
end
