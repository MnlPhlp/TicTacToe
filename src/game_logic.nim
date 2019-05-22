import 
    turn_based_game,
    negamax,
    tables,
    strutils,
    random

type
    GameOfTicTacToe* = ref object of Game 
        field: array[3,array[3, int]]
        size: int

    Settings* = ref object
        name1*, name2*: string
        ai*: bool

const
    desc* = @[" ","X","0"]


method resetField(self: GameOfTicTacToe) {.base.} =
    for y in 0..2:
        for x in 0..2:
            self.field[x][y] = 0


method setup(self: GameOfTicTacToe, players: seq[Player]) =
    self.default_setup(players)
    self.resetField()


method set_possible_moves(self: GameOfTicTacToe, moves: var seq[string]) =
    for y in 0..2:
        for x in 0..2:
            if self.field[x][y] == 0:
                moves.add($(x+1) & $(y+1))
 

method make_move(self: GameOfTicTacToe, move: string): string =
    self.field[($move[0]).parseInt()-1][($move[1]).parseInt()-1] = self.current_player_number
    result = "set mark at " & move


method determine_winner(self: GameOfTicTacToe) =
    if self.winner_player_number != NO_WINNER_YET:
        return
    for line in self.field:
        # check for vertical lines
        if line[0]!=0 and line[0] == line[1] and line[1] == line[2]:
            self.winner_player_number = line[0]
            return
    for i in 0..2:
        #check for horizontal lines
        if self.field[0][i] != 0 and self.field[0][i] == self.field[1][i] and self.field[1][i] == self.field[2][i]:
            self.winner_player_number = self.field[0][i]
            return
    # check for a tie
    var staleMate = true
    for line in self.field:
      for square in line:
        if square==0:
            staleMate = false
    if staleMate:
        self.winner_player_number = STALEMATE


method status(self: GameOfTicTacToe): string =
    echo "  1  2  3"
    for y in 0..2:
        var line = $(y+1)
        for x in 0..2:
            line.add("[$1]".format(desc[self.field[x][y]]))
        echo line

method get_state(self: GameOfTicTacToe): string =
    for y in 0..2:
        for x in 0..2:
            result.add($self.field[x][y])

method restore_state(self: GameOfTicTacToe, state: string) =
    for y in 0..2:
        for x in 0..2:
            self.field[x][y] = ($state[y*3+x]).parseInt()
    
method scoring(self: GameOfTicTacToe): float =
    for line in self.field:
      for square in line:
        # for every square on the field check if marked by current player
        if square == self.current_player_number:
          # check every neighbour
          discard

method setup*(self: GameOfTicTacToe, s: Settings) {.base.} =
  if s.ai:
    self.setup(@[Player(name: s.name1),NegamaxPlayer(name: s.name2)])
  else:
    self.setup(@[Player(name: s.name1),Player(name: s.name2)])

method playOnCli*(self: GameOfTicTacToe) {.base.} =
  self.play()

method field*(self: GameOfTicTacToe): array[3,array[3, int]] {.base.} =
  self.field
  
method size*(self: GameOfTicTacToe): int {.base.}=
  self.size

method currentPlayer*(self: GameOfTicTacToe): string {.base.} =
  self.current_player
    


