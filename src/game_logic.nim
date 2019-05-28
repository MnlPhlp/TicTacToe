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
    winScore = 1_000_000
    lineScore =1_000


method setDefault*(self: Settings) {.base.} =
  # set default settings
  self.name1 = "player 1"
  self.name2 = "player 2"
  self.size = 3
  self.winCount = 3


method resetField(self: GameOfTicTacToe) {.base.} =
  self.field = newSeqWith(self.size,newSeq[int](self.size))


method setup(self: GameOfTicTacToe, players: seq[Player]) =
    self.default_setup(players)
    self.resetField()


method set_possible_moves(self: GameOfTicTacToe, moves: var seq[string]) =
    for y in 0..self.size-1:
        for x in 0..self.size-1:
            if self.field[x][y] == 0:
                moves.add(fmt"{x+1}.{y+1}")
 

method make_move(self: GameOfTicTacToe, move: string): string =
    self.field[($move.split('.')[0]).parseInt()-1][($move.split('.')[1]).parseInt()-1] = self.current_player_number
    result = "set mark at " & move


method getLines(self: GameOfTicTacToe): seq[seq[int]] {.base.} =
  let s = self.size-1
  var vLine: seq[int] # vetical
  var hLine: seq[int] # horizontal
  var sLine1: seq[int] # slanted
  var sLine2: seq[int] # slanted
  var sLine3: seq[int] # slanted
  var sLine4: seq[int] # slanted
  for i in 0..s:
    vLine = @[]
    hLIne = @[]
    sLine1 = @[]
    sLine2 = @[]
    sLine3 = @[]
    sLine4 = @[]
    for j in 0..s:
      # create vertical lines
      vLine.add(self.field[i][j])
      # create horizontal lines
      hLine.add(self.field[j][i])
      # create slanted lines
      if i+j <= s:
        sLine1.add(self.field[i+j][j])
        sLine2.add(self.field[i+j][s-j])
        if i > 0: # avoid double middle line
          sLine3.add(self.field[s-(i+j)][j])
          sLine4.add(self.field[s-(i+j)][s-j])
    if hLine.len >= self.winCount:
      result.add(hLine)
    if vLine.len >= self.winCount:
      result.add(vLine)
    if sLine1.len >= self.winCount:
      result.add(sLine1)
    if sLine2.len >= self.winCount:
      result.add(sLine2)
    if i > 0: # avoid double middle line
      if sLine3.len >= self.winCount:
        result.add(sLine3)
      if sLine4.len >= self.winCount:
        result.add(sLine4)



proc maxLineLength(line: seq[int]): (int,int) =
  # check for continuous lines
  result[1] = line[0]
  for field in line:
    if field != 0: # skip empty fields
      if field == result[1]:
        # count line Length
        inc result[0]
      else:
        # reset line Length
        result[0] = 1
        result[1] = field


method determine_winner(self: GameOfTicTacToe) =
  if self.winner_player_number != NO_WINNER_YET:
      return
  for line in self.getLines:
    # check for a winning line
    let maxLength = line.maxLineLength
    if  maxLength[0] >= self.winCount:
      self.winner_player_number = maxLength[1]
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
            self.field[x][y] = ($state[y*self.size+x]).parseInt()
    
method scoring(self: GameOfTicTacToe): float =
  for line in self.getLines:
    let maxLen = line.maxLineLength
    if maxLen[0] >= self.winCount: # if a player won 
      if self.current_player_number == maxLen[1]:
        result += winScore # good if current player won
      else: 
        result -= winScore # bad if opponent won
    else: # give the player with longer line points depending on line length
      if maxLen[0] > 1:
        if self.current_player_number == maxLen[1]:
          result += lineScore * (float)maxLen[0]
        else: 
          result -= lineScore * (float)maxLen[0]
        

method setup*(self: GameOfTicTacToe, s: Settings) {.base.} =
  self.size = s.size
  self.winCount = if s.winCount == 0: s.size else: s.winCount
  if s.ai:
    self.setup(@[Player(name: s.name1),NegamaxPlayer(name: s.name2, depth: 3)])
  else:
    self.setup(@[Player(name: s.name1),Player(name: s.name2)])

method playOnCli*(self: GameOfTicTacToe) {.base.} =
  self.play()

method field*(self: GameOfTicTacToe): seq[seq[int]] {.base.} =
  self.field
  
method size*(self: GameOfTicTacToe): int {.base.} =
  self.size

method winCount*(self: GameOfTicTacToe): int {.base.} =
  self.winCount


method getPlayerName*(self: GameOfTicTacToe): string {.base.} =
  if self.current_player == nil:
    "Game is not setup yet"
  else:
    self.current_player.name


method make_turn*(self: GameOfTicTacToe, move: string) {.base.} = 
  if self.is_over:
    return
  discard self.make_move(move)
  self.determine_winner()
  if self.is_over():
    return
  self.finish_turn()
  # if playing agains ai do it's turn
  if self.current_player of NegamaxPlayer:
    discard self.make_move(self.current_player.get_move(self))
    self.finish_turn()


method finished*(self: GameOfTicTacToe): bool {.base.}=
  self.is_over

