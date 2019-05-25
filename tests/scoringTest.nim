include ../src/game_logic

let game = new(GameOfTicTacToe)
game.current_player_number=2
game.size=3
game.winCount=3
game.field = @[@[1,2,2],
               @[1,1,0],
               @[0,0,2]]
echo game.scoring()            
game.field = @[@[1,0,2],
               @[1,1,2],
               @[0,0,2]]
echo game.scoring() 