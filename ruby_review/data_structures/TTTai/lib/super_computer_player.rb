require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    board = game.board
    node = TicTacToeNode.new(board, mark)

    # If any move results in a #winning_node? we want to choose that
    # one. Find picks the first of the winning moves in
    # `possible_moves`.
    node.children.each do |child|
      return child.prev_move_pos if child.winning_node?(mark)
    end

    # Maybe there is no winning move. Then at least don't pick a
    # loser.
    node.children.each do |child|
      return child.prev_move_pos if !child.losing_node?(mark)
    end
    
    # If the computer plays perfectly, we should never be able to
    # force it to lose. Let's raise an alarm in that case!
    raise "cannot find a winning or draw inducing move"
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
