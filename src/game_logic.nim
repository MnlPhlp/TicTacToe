import 
    turn_based_game,
    negamax,
    strformat,
    strutils,
    sequtils

type
    GameOfTicTacToe* = ref object of Game 
        field: seq[seq[int]]
        size: int
        winCount: int

    Settings* = ref object
        name1*, name2*: string
        ai*: bool
        size*: int
        winCount*: int

const
    desc* = @[" ","X","0"]


method resetField(self: GameOfTicTacToe) {.base.} =
  self.field = newSeqWith(self.size,newSeq[int](self.size))


method setup(self: GameOfTicTacToe, players: seq[Player]) =
    self.default_setup(players)
    self.resetField()


method set_possible_moves(self: GameOfTicTacToe, moves: var seq[string]) =
    for y in 0..self.size-1:
        for x in 0..self.size-1:
            if self.field[x][y] == 0:
                moves.add($(x+1) & $(y+1))
 

method make_move(self: GameOfTicTacToe, move: string): string =
    self.field[($move[0]).parseInt()-1][($move[1]).parseInt()-1] = self.current_player_number
    result = "set mark at " & move


method determine_winner(self: GameOfTicTacToe) =
  if self.winner_player_number != NO_WINNER_YET:
      return
  var lineLength = 0
  for line in self.field:
    # check for vertical lines
    var startField = line[0]
    lineLength = 0
    for field in line:
      if field == startField:
        # count line Length
        inc lineLength
      else:
        # reset line Length
        lineLength = 1
        startField = field
    if lineLength == self.winCount:
      self.winner_player_number = startField
      return
  # check for a tie
  if all(self.field, 
    proc (line: seq[int]):bool = 
      all(line, proc (x:int):bool =
        x != 0)): 
    self.winner_player_number = STALEMATE


method status*(self: GameOfTicTacToe):string =
    var topLine = ""
    for i in 1..self.size:
      topLine &= fmt"  {i}"
    echo topLine
    for y in 0..self.size-1:
        var line = $(y+1)
        for x in 0..self.size-1:
            line.add("[$1]".format(desc[self.field[x][y]]))
        echo line

method get_state(self: GameOfTicTacToe): string =
    for y in 0..self.size-1:
        for x in 0..self.size-1:
            result.add($self.field[x][y])

method restore_state(self: GameOfTicTacToe, state: string) =
    for y in 0..self.size-1:
        for x in 0..self.size-1:
            self.field[x][y] = ($state[y*3+x]).parseInt()
    
method scoring(self: GameOfTicTacToe): float =
    for line in self.field:
      for square in line:
        # for every square on the field check if marked by current player
        if square == self.current_player_number:
          # check every neighbour
          discard

method setup*(self: GameOfTicTacToe, s: Settings) {.base.} =
  self.size = s.size
  self.winCount = s.winCount
  if s.ai:
    self.setup(@[Player(name: s.name1),NegamaxPlayer(name: "ai")])
  else:
    self.setup(@[Player(name: s.name1),Player(name: s.name2)])

method playOnCli*(self: GameOfTicTacToe) {.base.} =
  self.play()

method field*(self: GameOfTicTacToe): seq[seq[int]] {.base.} =
  self.field
  
method size*(self: GameOfTicTacToe): int {.base.}=
  self.size


method getPlayer*(self: GameOfTicTacToe): string {.base.} =
  if self.current_player == nil:
    "Game is not setup yet"
  else:
    self.current_player.name


method make_turn*(self: GameOfTicTacToe, move: string): string {.base.} = 
  result = "playing"
  if self.is_over:
    return "Game is Over"
  discard self.make_move(move)
  self.determine_winner()
  if self.is_over():
    if self.winner_player_number == STALEMATE:
        result = "It's a tie"
    else:
        result = fmt"Winner is {self.winning_player.name}"
    return
  self.finish_turn()
  # if playing agains ai do it's turn
  if self.current_player of NegamaxPlayer:
    discard self.make_move(self.current_player.get_move(self))
    self.finish_turn()


method finished*(self: GameOfTicTacToe): bool {.base.}=
  self.is_over


