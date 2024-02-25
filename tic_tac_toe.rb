# frozen_string_literal: true
# typed: true

# Contains the logic for the game
class TicTacToe
  @game_board = [
    ['-', '-', '-'],
    ['-', '-', '-'],
    ['-', '-', '-']
  ]

  def show_board
    @game_board.each { |row| p row }
  end
end

game = TicTacToe.new

game.show_board
