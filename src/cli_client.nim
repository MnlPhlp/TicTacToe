import 
    rdstdin,
    game_logic,
    strutils

let game = new(GameOfTicTacToe)
let settings = new(Settings)
settings.name1 = readLineFromStdin("name 1: ")
settings.name2 = readLineFromStdin("name 2: ")
settings.ai = (readLineFromStdin("ai? [Y/n]: ") in ["y","Y",""])
settings.size = readLineFromStdin("size (width): ").parseInt()
settings.winCount = readLineFromStdin("line length to win: ").parseInt()
game.setup(settings)
game.playOnCli