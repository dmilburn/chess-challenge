require_relative 'chess_model.rb'

players = ["white", "black"]
game = Board.new
game.set_up_board
@v2m_conversion = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h"=> 7}
@m2v_conversion = @v2m_conversion.invert

def reset_screen!
  print "\e[2J\e[H"
end

def v2m_coord_converter(view_coord)
  [view_coord[1].to_i - 1, @v2m_conversion[view_coord[0]]]
end

def m2v_coord_converter(model_coord_array)
  model_coord_array.map do |model_coord|
    [@m2v_conversion[model_coord[1]], model_coord[0] + 1].join("")
  end.join(", ")
end

moves = ""
while !game.check_mate? do
  players.each do |player|
    reset_screen!
    puts game.to_s
    model_coord, view_coord, move_coord, piece, moves, model_move_coord = ""
    puts "#{player} is in check" if game.check?
    loop do
      puts "#{player}'s turn"
      puts "#{player}, which piece would you like to move?"
      view_coord = gets.chomp.downcase
      model_coord = v2m_coord_converter(view_coord)
      if game.valid_spot?(model_coord, player)
        piece = game.coordinate_to_object(model_coord)
        moves = game.check_move_helper(piece)
      end
      break if moves != nil
      puts "Invalid selection"
    end
    loop do
      puts "Moves for #{player} #{piece.class.to_s.downcase} are #{m2v_coord_converter(moves)}"
      puts "Which move would you like?"
      move_coord = gets.chomp.downcase
      model_move_coord = v2m_coord_converter(move_coord)
      break if moves.include?(model_move_coord)
      puts "Invalid selection"
    end
    if game.capture_piece?(model_move_coord)
      string = "Okay, #{player} #{piece.class.to_s.downcase} captures #{game.board[model_move_coord[0]][model_move_coord[1]].class.to_s.downcase}"
    else
    string = "Okay, #{player} #{piece.class.to_s.downcase} moves to #{move_coord}"
    end
    game.place(piece, model_move_coord )
    puts string
    sleep(0.25)
  end
end

puts "Check mate!!!"
