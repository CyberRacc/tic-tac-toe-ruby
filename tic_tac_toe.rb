# frozen_string_literal: true
# typed: true

# TicTacToe Class
class TicTacToe
  def initialize
    welcome_message
    player = Player.new(user_name, user_symbol)
    cpu = Player.new('CPU', player.symbol == 'X' ? 'O' : 'X')
    puts player
    puts cpu
  end

  @game_board = [
    ['-', '-', '-'],
    ['-', '-', '-'],
    ['-', '-', '-']
  ]

  def show_board
    @game_board.each { |row| p row }
  end

  private

  def update_board(row, index, symbol)
    @game_board[row][index] = symbol
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
    print 'Choose your symbol (X)/(O): '
    print 'Choose your symbol (X)/(O): ' while gets.chomp.upcase != 'X'
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

TicTacToe.new
