require_relative "chess_model"

describe "Board" do
  let(:pawn) {Pawn.new({color: "white", position: [1,0]})}
  let(:bpawn) {Pawn.new({color: "black", position: [6,0]})}
  let(:king) {King.new({color: "white", position: [1,1]})}
  let(:queen) {Queen.new({color: "white", position: [1,2]})}
  let(:knight) {Knight.new({color: "white", position: [3,3]})}
  let(:bishop) {Bishop.new({color: "white", position: [2,3]})}
  let(:rook) {Rook.new({color: "white", position: [1,5]})}
  let(:king_move_test_brook) {Rook.new({color: "black", position: [2,1]})}
  let(:king_move_test_queen) {Queen.new({color: "white", position: [2,2]})}
  let(:rook_move_test_knight) {Knight.new({color: "white", position: [2,5]})}
  let(:rook_move_test_bpawn) {Rook.new({color: "black", position: [1,4]})}
  let(:knight_move_test_pawn) {Pawn.new({color: "white", position: [1,2]})}
  let(:knight_move_test_pawn2) {Pawn.new({color: "white", position: [1,4]})}
  let(:knight_move_test_bknight) {Knight.new({color: "black", position: [5,4]})}
  let(:queen_move_test_bking) {King.new({color: "black", position: [4,2]})}
  let(:queen_move_test_bishop) {Bishop.new({color: "white", position: [1,5]})}
  let(:bishop_move_test_bbishop) {Bishop.new(color: "black", position:[4,5])}
  let(:bishop_move_test_brook) {Rook.new(color: "black", position:[0,1])}
  let(:bishop_move_test_queen) {Queen.new(color: "white", position:[4,1])}
  let(:bishop_move_test_pawn) {Pawn.new(color: "white", position:[0,5])}
  let(:chess_board) {Board.new}
  let(:wking) {chess_board.instance_variable_get(:@wking)}
  let(:bking) {chess_board.instance_variable_get(:@bking)}

  describe "initialize" do
    it "should initialize to nil" do
      chess_board.board.each do |row|
        row.each do |space|
          expect(space).to eq nil
        end
      end
    end
  end

  describe "initialize_white_pieces" do
    it "should create an array of white piece objects" do
      chess_board.white_pieces_array do |piece|
        expect(piece.color).to eq "white"
      end
    end
  end

  describe "initialize_black_pieces" do
    it "should create an array of black piece objects" do
      chess_board.black_pieces_array do |piece|
        expect(piece.color).to eq "black"
      end
    end
  end

  describe "place" do
    it "should push a piece object into the board array corresponding to the piece's position" do
      chess_board.place(pawn, [5,0])
      expect(chess_board.board[5][0].is_a?(Pawn)).to eq true
    end
    it "should update the position of the piece after placing it on the board" do
      chess_board.place(pawn, [7,7])
      expect(pawn.position).to eq [7,7]
    end
    it "should set the pieces previous position to nil" do
      chess_board.place(king, [1,0])
      chess_board.place(king, [5,6])
      expect(chess_board.board[1][0]).to eq nil
    end
  end

  describe "pawn_move for white pawn" do
    it "should return an array of moves for the pawn passed" do
      expect(chess_board.check_pawn_move(pawn)).to eq [[2,0],[3,0]]
    end
  end

  describe "pawn_move for black pawn" do
  	it "should return an array of moves for the pawn passed" do
      expect(chess_board.check_pawn_move(bpawn)).to eq [[5,0],[4,0]]
    end
  end

  describe "kk_move(king)" do
    it "should return an array of moves for the king passed" do
      chess_board.place(king, [1,1])
      expect(chess_board.check_kk_move(king)).to eq [[2,1], [2,2], [1,2],[0,2],[0,1],[0,0],[1,0],[2,0]]
    end
  end

  describe "kk_move(king)" do
  	it "should handle pieces existing on squares that could fall within valid moves" do
  	  chess_board.place(king, [1,1])
  	  chess_board.place(king_move_test_queen, [2,2])
  	  chess_board.place(king_move_test_brook, [2,1])
  	  expect(chess_board.check_kk_move(king)).to eq [[2,1],[1,2],[0,2],[0,1],[0,0],[1,0],[2,0]]
  	end
  end

  describe "kk_move(knight)" do
    it "should return an array of moves for the knight passed(including collisions)" do
      chess_board.place(knight, [3,3])
      chess_board.place(knight_move_test_pawn, [1,2])
      chess_board.place(knight_move_test_pawn2, [1,4])
   	  chess_board.place(knight_move_test_bknight, [5,4])
      expect(chess_board.check_kk_move(knight).sort).to eq [[5,2],[5,4], [4,5], [2,5], [2,1], [4,1]].sort
    end
  end

  describe "rqb_move(rook)" do
    it "should return an array of moves for the rook passed" do
      chess_board.place(rook, [1,5])
      expect(chess_board.check_rqb_move(rook)).to eq [[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[1,6],[1,7],[0,5],[1,4],[1,3],[1,2],[1,1],[1,0]]
    end
  end

  describe "rbq_move(rook)" do
  	it "should handle pieces existing on squares that could fall within valid moves(collisions with black at 1,4 and white at 2,5" do
  		chess_board.place(rook, [1,5])
  		chess_board.place(rook_move_test_bpawn, [1,4])
  		chess_board.place(rook_move_test_knight, [2,5])
  		expect(chess_board.check_rqb_move(rook)).to eq [[1,6],[1,7],[0,5],[1,4]]
  	end
  end

  describe "rqb_move(queen)" do
    it "should return an array of moves for the queen passed(including collisions w/ black at 4,2 and white at 1,5)" do
      chess_board.place(queen, [1,2])
      chess_board.place(queen_move_test_bishop, [1,5])
      chess_board.place(queen_move_test_bking, [4,2])
      expect(chess_board.check_rqb_move(queen)).to eq [[2,2],[3,2],[4,2],[2,3],[3,4],[4,5],[5,6],[6,7],[1,3],[1,4],[0,3],[0,2],[0,1],[1,1],[1,0],[2,1],[3,0]]
    end
  end

  describe "rqb_move(bishop)" do
    it "should return an array of moves for the bishop passed" do
      chess_board.place(bishop, [2,3])
      chess_board.place(bishop_move_test_pawn, [0,5])
      chess_board.place(bishop_move_test_queen, [4,1])
      chess_board.place(bishop_move_test_brook, [0,1])
      chess_board.place(bishop_move_test_bbishop, [4,5])
      expect(chess_board.check_rqb_move(bishop)).to eq [[3,4],[4,5],[1,4],[1,2],[0,1],[3,2]]
    end
  end

  describe "check_mate?" do
    it "should return true if the black king is captured" do
      chess_board.place(knight, knight.position)
      chess_board.place(bking, [2,5])
      chess_board.place(knight, [2,5])
      expect(chess_board.check_mate?).to eq true
    end

    it "should return true if the white king is captured" do
      chess_board.place(wking, [3,3])
      chess_board.place(king_move_test_brook, [3,2])
      chess_board.place(king_move_test_brook, [3,3])
      expect(chess_board.check_mate?).to eq true
    end

    it "should return false if a piece other than king is captured" do
      chess_board.place(knight, knight.position)
      chess_board.place(bishop_move_test_bbishop, [1,2])
      chess_board.place(knight, [1,2])
      expect(chess_board.check_mate?).to eq false
    end
  end
end


