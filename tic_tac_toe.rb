# frozen_string_literal: true
# typed: true

# Utilities module
module Utils
  def clear_console
    Kernel.system('clear') || Kernel.system('cls')
  end

  def welcome_message
    Kernel.puts "Welcome to CyberRacc's Tic Tac Toe game in Ruby!"
  end
end

# Methods related to the Gameboard
class GameBoard
  include Utils

  WINNING_COMBINATIONS = [
    [0, 1, 2], # top row
    [3, 4, 5], # middle row
    [6, 7, 8], # bottom row
    [0, 3, 6], # left column
    [1, 4, 7], # middle column
    [2, 5, 8], # right column
    [0, 4, 8], # diagonal top-left to bottom-right
    [2, 4, 6]  # diagonal top-right to bottom-left
  ].freeze # The .freeze method is called on this array to prevent it from being changed since it's a constant.

  def initialize
    # 2D Grid array for the game board
    @game_board = [
      ['-', '-', '-'],
      ['-', '-', '-'],
      ['-', '-', '-']
    ]
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
    puts 'Move is valid' if @game_board[row][column] == '-'
  end

  # Should be executed after every move
  def check_win
    WINNING_COMBINATIONS.each do |win_combo|
      win_combo.all? { |position| @game_board[position] == 'O' || @game_board[position] == 'X' }
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
end

# TicTacToe Class
class TicTacToe
  include Utils

  def initialize
    welcome_message
    @player = Player.new(user_name, user_symbol)
    @cpu = Player.new('CPU', @player.symbol == 'X' ? 'O' : 'X')
    @game_board = GameBoard.new
    prompt_game
  end

  private

  def cpu_move
    rand_row = rand(0..2)
    rand_col = rand(0..2)
    update_board(rand_row, rand_col, @cpu.symbol)

    # After move has been made, check if the game as been won.
    if @game_board.check_win == false
      player_move
    else
      declare_winner(@cpu)
    end
  end

  def player_move
    player_row = T.let(nil, T.untyped)
    player_col = T.let(nil, T.untyped)

    loop do
      player_row = player_choice('row')
      player_col = player_choice('column')

      break if @game_board.move_valid?(player_row, player_col)

      puts 'Invalid move. Please try again.'
    end

    update_board(player_row, player_col, @player.symbol)

    @game_board.check_win == false ? cpu_move : declare_winner(@player)
  end

  def player_choice(position)
    loop do
      print "Which #{position} do you want to place your #{@player.symbol}? (0, 1, 2): "
      choice = gets.chomp.to_i
      return choice if (0..2).include?(choice)

      puts "Invalid #{position}. Please choose a valid #{position}."
    end
  end

  def declare_winner(winner)
    puts "The winner is #{winner}!"
    @game_board.play_again
  end

  def prompt_game
    print 'Start game? (y/n): '
    if gets.chomp.downcase == 'y'
      @game_board.start_game
    else
      puts 'Game Stopped'
      nil
    end
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
      break if %w[X O].include?(sym)
    end
    sym
  end

  def first_mover
    winner = determine_first_mover
    puts "The winner is #{winner}, they get first move."
    winner
  end

  def determine_first_mover
    user_num, cpu_num = user_and_cpu_numbers
    cpu_num > user_num ? 'cpu' : 'player'
  end

  def user_and_cpu_numbers
    user_num = user_number
    cpu_num = rand(1..10)
    puts "Player Number: #{user_num}"
    puts "CPU Number: #{cpu_num}"
    [user_num, cpu_num]
  end

  def user_number
    loop do
      print 'Enter a number from 1 to 10: '
      user_num = gets.chomp.to_i
      return user_num if (1..10).include?(user_num)
    end
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
