# frozen_string_literal: true
# typed: true

# Utilities module
module Utils
  def clear_console
    Kernel.system('clear') || Kernel.system('cls')
  end
end

# TicTacToe Class
class TicTacToe
  include Utils

  def initialize
    # 2D Grid array for the game board
    @game_board = [
      ['-', '-', '-'],
      ['-', '-', '-'],
      ['-', '-', '-']
    ]
    welcome_message
    @player = Player.new(user_name, user_symbol)
    @cpu = Player.new('CPU', @player.symbol == 'X' ? 'O' : 'X')
    prompt_game
  end

  private

  def start_game
    clear_console
    show_board
    if first_mover == 'cpu'
      clear_console
      puts "Making CPU Move"
      cpu_move
    else
      clear_console
      puts "Making Player Move"
      player_move
    end
  end

  def cpu_move
    # Rows: 0-2
    # Columns: 0-2
    rand_row = rand(0..2)
    rand_col = rand(0..2)
    update_board(rand_row, rand_col, @cpu.symbol)

    # After move has been made, check if the game as been won.
    if check_win == false
      player_move
    else
      declare_winner(@cpu)
    end
  end

  def player_move
    player_row = 0
    player_col = 0

    # Nested loop to get player row and col choice and check if move is valid
    loop do
      # Get the user's row choice
      loop do
        print "Which column do you want to place your #{@player.symbol}? (0, 1, 2): "
        player_row = gets.chomp.to_i
        break if (0..2).include?(player_row.to_i)
      end

      # Get the user's column choice
      loop do
        print "Which column do you want to place your #{@player.symbol}? (0, 1, 2): "
        player_col = gets.chomp.to_i
        break if (0..2).include?(player_col.to_i)
      end
      break if move_valid?(player_row, player_col)
    end

    update_board(player_row, player_col, @player.symbol)

    # May need a check here for if the board is already full
    # Maybe a predicate method like board_full?

    if check_win == false
      cpu_move
    else
      declare_winner(@player)
    end
  end

  def declare_winner(winner)
    puts "The winner is #{winner}!"
    play_again
  end

  def play_again
    answer = gets.chomp.downcase
    if answer == 'y'
      clear_console
      clear_board
    else
      exit
    end
  end

  def clear_board
    @game_board = [
      ['-', '-', '-'],
      ['-', '-', '-'],
      ['-', '-', '-']
    ]
  end

  # Predicate method to check if the current move is valid.
  def move_valid?(row, column)
    puts "Move is valid" if @game_board[row][column] == '-'
  end

  # Should be executed after every move
  def check_win
    # May want to define this elswhere like in initialize, but should be fine.
    winning_combinations = [
      [0, 1, 2], # top row
      [3, 4, 5], # middle row
      [6, 7, 8], # bottom row
      [0, 3, 6], # left column
      [1, 4, 7], # middle column
      [2, 5, 8], # right column
      [0, 4, 8], # diagonal top-left to bottom-right
      [2, 4, 6]  # diagonal top-right to bottom-left
    ]

    winning_combinations.each do |win_combo|
      if win_combo.all? { |position| @game_board[position] == 'O' }
        return true
      elsif win_combo.all? { |position| @game_board[position] == 'X' }
        return true
      else
        return false
      end
    end
  end

  def prompt_game
    print "Start game? (y/n): "
    if gets.chomp.downcase == 'y'
      start_game
    else
      puts 'Game Stopped'
      return
    end
  end

  def show_board
    puts "\n"
    puts "\n"
    @game_board.each { |row| p row }
    puts "\n"
    puts "\n"
  end

  def update_board(row, index, symbol)
    @game_board[row][index] = symbol
    show_board
    check_win
  end

  def welcome_message
    puts "Welcome to CyberRacc's Tic Tac Toe game in Ruby!"
  end

  def user_name
    puts "What's your name?"
    print 'My name is: '
    gets.chomp.to_s
  end

  def user_symbol
    sym = String.new
    loop do
      print 'Choose your symbol (X)/(O): '
      sym = gets.chomp.upcase
      break if sym == 'X' || sym == 'O'
    end
    return sym
  end

  # Determines the first player to make a move based on random chance.
  def first_mover
    puts "To determine who goes first, choose a number between 1 and 10"
    print "Enter a number from 1 to 10: "
    user_num = gets.chomp.to_i
    winner = String.new

    # Chooses random number between 1 and 10 for CPU.
    cpu_num = rand(1..10)

    # Determine winner based on who picked the higher number
    if cpu_num > user_num
      winner = 'cpu'
    elsif user_num > cpu_num
      winner = 'player'
    else
      loop do
        print "Enter a number from 1 to 10: "
        user_num = gets.chomp.to_i
        cpu_num = rand(1..10)
        break if (1..10).include?(user_num)
      end
      winner = cpu_num > user_num ? 'cpu' : 'player'
    end

    puts "Player Number: #{user_num}"
    puts "CPU Number: #{cpu_num}"
    puts "The winner is #{winner}, they get first move."
    return winner
  end

end

# Define base class for Player and Player functions
class Player
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    display_player_info
  end

  def display_player_info
    puts "#{@name}'s Symbol: #{@symbol}"
  end

  attr_reader :name, :symbol
end

# Create game instance
TicTacToe.new
