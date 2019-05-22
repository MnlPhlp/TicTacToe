import 
    rdstdin,
    strutils,

    game_logic

proc play() =
    let game = new(GameOfTicTacToe)
    let name1 = readLineFromStdin("Enter Name of Player1: ")
    let name2 = readLineFromStdin("Enter Name of Player2 (or AI): ")
    if name2.toUpper == "AI":
        game.setup(name1, name2, true)
    else:
        game.setup(name1, name2, false)

    game.playOnCli()

if is_main_module:
    play()