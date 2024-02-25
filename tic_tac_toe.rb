# typed: true

# Contains the
class TicTacToe
  @@game_board = [
    ['-', '-', '-'],
    ['-', '-', '-'],
    ['-', '-', '-']
  ]

  def self.show_board
    @@game_board.each { |row| p row }
  end
end

TicTacToe.show_board
