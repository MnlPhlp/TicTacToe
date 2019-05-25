include ../src/game_logic

#######################################
##############  Testing    ############
#######################################
let game = new(GameOfTicTacToe)
game.current_player_number=1
game.size=3
game.winCount=3
game.field = @[@[11,13,15],
               @[31,33,35],
               @[51,53,55]]

var testField: seq[string]
for line in game.getLines:
  testField = @[" | | ","-----"," | | ","-----"," | | "]
  for field in line:
    testField[((int)(field/10))-1][(field mod 10)-1] = 'X'
  for row in testField:
    echo row
  echo ""
  echo "#############"
  echo ""

echo fmt"total posibilities: {game.getLines.len}"
