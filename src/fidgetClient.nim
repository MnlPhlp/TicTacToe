import fidget,os,chroma,math
import game_logic,colorScheme

let game = new(GameOfTicTacToe)
let settings = new(Settings)
var winnerAnnounced = false
var gameStarted = false
var startingPlayer = 1

settings.setDefault()
game.setup(settings)

when not defined(js):
    import typography,tables
    fonts["IBM Plex Sans Regular"] = readFontSvg(getAppDir() & "/data/IBMPlexSans-Regular.svg")
    fonts["IBM Plex Sans Bold"] = readFontSvg(getAppDir() & "/data/IBMPlexSans-Bold.svg")

proc startGame() = 
    game.setup(settings)
    game.resetLeaderboard()
    gameStarted = true

proc makeSquare() =
    if current.box.w > current.box.h:
        current.box.x += (current.box.w - current.box.h) / 2
        current.box.w = current.box.h
    if current.box.h > current.box.w:
        current.box.h = current.box.w
    current.screenBox = current.box + parent.screenBox

proc checkWinner() =
    if not winnerAnnounced:
        if game.winner_player_number != 0:
            if game.winner_player_number == -1:
                echo "Draw"
            else:
                echo game.getPlayerName() & " won the game!"
            

proc drawGameField() =
    let fieldWidth = min(current.box.w,current.box.h)
    let boxWidth = (int)(fieldWidth - 2) / game.field.len - 2
    var x,y = 2.0
    var dark = false
    for i,row in game.field:
        x = 2
        for j,field in row:
            rectangle "field":
                box x,y,boxWidth,boxWidth
                if dark:
                    fill colors.fieldDark
                else:
                    fill colors.fieldLight
                dark = not dark
                # if field is empty allow clicking
                if field == 0:
                    onClick:
                        game.makeTurn($(i+1) & "." & $(j+1))
                        checkWinner()
                rectangle "symbol":
                    box 5,5,parent.box.w-10,parent.box.h-10
                    if field == 1:
                        image "x"
                    if field == 2:
                        image "0"
            x += boxWidth + 2
        y += boxWidth + 2


proc drawLeaderboard() =
  let history = game.getLeaderboard().history
  let histLen = history.len
  if histLen > 0:
    let maxEntries = (int) floor(current.box.h / 40) # calculate amount of entries that fit
    let entries = min(maxEntries,histLen)
    let startEntry = if entries == histLen: 0 else: histLen - entries
    for i in startEntry .. startEntry + entries - 1:
        group "entry":
            box 0,(i-startEntry)*40,40,300
            text "round":
                box 0,0,99,40
                font "IBM Plex Sans Regular", 32, 200, 0, 0, 0
                fill colors.lbText
                characters $(i+1)
                if history[i] == 1:
                    rectangle "x":
                        box 134,4,32,32
                        image "x"
                if history[i] == 2:
                    rectangle "0":
                        box 234,4,32,32
                        image "0"

proc drawInfo() =
    frame "Info":
        box 20, 40, 300, 655
        constraints cMin, cStretch
        rectangle "Rectangle 4":
          box 20, 10, 260, 50
          constraints cMin, cMin
          fill "#c4c4c4"
          cornerRadius 25
          strokeWeight 1
        text "current Game":
          box 20, 10, 260, 50
          fill "#000000"
          font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
          characters "current Game"
        group "SettingButtons":
          box 45, 252, 200, 50
          rectangle "resetButton":
            box 0, 0, 200, 50
            constraints cMin, cMin
            fill "#c4c4c4"
            cornerRadius 25
            onClick:
                gameStarted = false
            onHover:
                fill colors.buttonHover
            onDown:
                fill colors.buttonPressed
          text "reset":
            box 0, 0, 200, 50
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
            characters "reset"
          rectangle "next":
            box 0,60,200,50
            constraints cMin, cMin
            fill colors.buttonColor
            cornerRadius 25
            strokeWeight 1
            onClick:
                game.setup(settings)
                startingPlayer = if startingPlayer == 1: 2 else: 1
                game.current_player_number = startingPlayer
            onHover:
                fill colors.buttonHover
            onDown:
                fill colors.buttonPressed
            text "start":
                box 0,0,parent.box.w,parent.box.h
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 36, 200, 0, 0, -1
                characters "next round"
        group "current Player":
          box 0, 155, 294, 40
          text "player":
            box 0, 0, 170, 40
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
            characters "current player: "
          text "curPlayer":
            box 172, 0, 122, 40
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
            characters "Player 1"
        group "current Symbol":
          box 0, 204, 214, 33
          text "symbol":
            box 0, 0, 178, 33
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
            characters "current symbol: "
          text "curSymbol":
            box 182, 0, 32, 33
            constraints cMin, cMin
            fill "#00ff00"
            strokeWeight 1
            font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
            characters "X"
        group "winLength":
          box 0, 110, 267, 40
          text "line-length to win:":
            box 0, 0, 213, 40
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
            characters "line-length to win: "
          text "winLength":
            box 213, 0, 54, 40
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
            characters "3"

proc drawSettings() =
    frame "Settings":
        var buttonColor: Color
        box 20, 40, 300, 655
        constraints cMin, cStretch
        cornerRadius 0
        strokeWeight 1
        rectangle "Rectangle 4":
            box 20, 10, 260, 50
            constraints cMin, cMin
            fill "#c4c4c4"
            cornerRadius 25
            strokeWeight 1
        text "Settings":
            box 20, 10, 260, 50
            constraints cMin, cMin
            fill "#000000"
            strokeWeight 1
            font "IBM Plex Sans Regular", 36, 200, 0, 0, -1
            characters "Settings"
        group "SettingButtons":
            box 45, 360, 200, 50
            rectangle "startButton":
                box 0, 0, 200, 50
                constraints cMin, cMin
                fill colors.buttonColor
                cornerRadius 25
                strokeWeight 1
                onClick:
                    startGame()
                onHover:
                    fill colors.buttonHover
                onDown:
                    fill colors.buttonPressed
            text "start":
                box 0, 0, 200, 50
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 36, 200, 0, 0, -1
                characters "start"
        group "P2Name":
            box 0, 155, 276, 40
            text "Player 2:":
                box 0, 0, 120, 40
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, -1, -1
                characters "Player 2: "
            rectangle "P1Name":
                box 120, 0, 156, 40
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 0
                strokeWeight 1
            rectangle "P1Name":
                box 121, 1, 154, 38
                constraints cMin, cMin
                fill "#eeeeee"
                cornerRadius 0
                strokeWeight 1
            text "P2NameInput":
                box 121, 1, 154, 38
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, 0, -1
                binding settings.name2
        group "P1Name":
            box 0, 110, 276, 40
            text "Player 1:":
                box 0, 0, 120, 40
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, -1, -1
                characters "Player 1: "
            rectangle "P1Name":
                box 120, 0, 156, 40
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 0
                strokeWeight 1
            rectangle "P1Name":
                box 121, 1, 154, 38
                constraints cMin, cMin
                fill "#eeeeee"
                cornerRadius 0
                strokeWeight 1
            text "P1NameInput":
                box 121, 0, 154, 38
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, 0, -1
                binding settings.name1
        group "FieldSize":
            box 0, 225, 265, 40
            text "Field Size:":
                box 0, 0, 130, 40
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, -1, -1
                characters "Field Size:"
            rectangle "P1Name":
                box 181, 0, 50, 40
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 0
                strokeWeight 1
            rectangle "P1Name":
                box 182, 1, 48, 38
                constraints cMin, cMin
                fill "#eeeeee"
                cornerRadius 0
                strokeWeight 1
            text "FieldSizeInput":
                box 182, 1, 48, 38
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, 0, -1
                characters $(settings.size)
            frame "MinField":
                box 145, 5, 30, 30
                constraints cMin, cMin
                buttonColor = colors.buttonColor
                onClick:
                    if settings.size > settings.winCount:
                        settings.size -= 1
                onHover:
                    buttonColor = colors.buttonHover
                onDown:
                    buttonColor = colors.buttonPressed
                rectangle "Rectangle 8":
                    box 0, 12.5, 30, 5
                    constraints cMin, cMin
                    fill buttonColor
                    cornerRadius 0
            frame "plusField":
                box 235, 5, 30, 30
                constraints cMin, cMin
                onClick:
                    if settings.size < 9:
                        settings.size += 1
                buttonColor = colors.buttonColor
                onHover:
                    buttonColor = colors.buttonHover
                onDown:
                    buttonColor = colors.buttonPressed
                rectangle "Rectangle 7":
                    box 12.5, 0, 5, 30
                    constraints cMin, cMin
                    fill buttonColor
                    cornerRadius 0
                    strokeWeight 1
                rectangle "Rectangle 8":
                    box 0, 12.5, 30, 5
                    constraints cMin, cMin
                    fill buttonColor
                    cornerRadius 0
                    strokeWeight 1
        group "Win Count":
            box 0, 270, 265, 40
            text "Win Count:":
                box 0, 0, 130, 40
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, -1, -1
                characters "Win Count: "
            rectangle "P1Name":
                box 181, 0, 50, 40
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 0
                strokeWeight 1
            rectangle "P1Name":
                box 182, 1, 48, 38
                constraints cMin, cMin
                fill "#eeeeee"
                cornerRadius 0
                strokeWeight 1
            text "WinCountInput":
                box 182, 1, 48, 38
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 24, 200, 0, 0, -1
                characters $(settings.winCount)
            frame "MinField":
                box 145, 5, 30, 30
                constraints cMin, cMin
                onClick:
                    if settings.winCount > 0:
                        settings.winCount -= 1
                buttonColor = colors.buttonColor
                onHover:
                    buttonColor = colors.buttonHover
                onDown:
                    buttonColor = colors.buttonPressed
                rectangle "Rectangle 8":
                    box 0, 12.5, 30, 5
                    constraints cMin, cMin
                    fill buttonColor
                    cornerRadius 0
                    strokeWeight 1
            frame "plusField":
                box 235, 5, 30, 30
                constraints cMin, cMin
                onClick:
                    if settings.winCount < settings.size:
                        settings.winCount += 1
                buttonColor = colors.buttonColor
                onHover:
                    buttonColor = colors.buttonHover
                onDown:
                    buttonColor = colors.buttonPressed
                rectangle "Rectangle 7":
                    box 12.5, 0, 5, 30
                    constraints cMin, cMin
                    fill buttonColor
                    cornerRadius 0
                    strokeWeight 1
                rectangle "Rectangle 8":
                    box 0, 12.5, 30, 5
                    constraints cMin, cMin
                    fill buttonColor
                    cornerRadius 0
                    strokeWeight 1

proc drawMainFrame() =
    frame "Frame 1":
        orgBox 0,0,1280,720
        box root.box
        constraints cMin, cMin
        fill "#ffffff"
        rectangle "Heading":
            box 400, 20, 480, 60
            constraints cCenter, cMin
            fill "#d7ba56"
            cornerRadius 30
            strokeWeight 1
            text "Tic-Tac-Toe":
                box 0, 0, 480, 60
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Bold", 48, 200, 0, 0, -1
                characters "Tic-Tac-Toe"
        frame "GameFrame":
            box 335, 90, 610, 610
            constraints cStretch, cStretch
            makeSquare()
            rectangle "Rectangle 2":
                box 0, 0, parent.box.h, parent.box.w
                fill "#c4c4c4"
                rectangle "Rectangle 3":
                    box 5, 5, parent.box.w - 10, parent.box.h - 10
                    fill "#eeeeee"
                    drawGameField()
        frame "Leaderboard":
            box 960, 40, 300, 655
            orgBox 960, 40, 300, 655
            constraints cMax, cStretch
            cornerRadius 0
            strokeWeight 1
            rectangle "Rectangle 4":
                box 20, 10, 260, 50
                constraints cMin, cMin
                fill "#c4c4c4"
                cornerRadius 25
                strokeWeight 1
            text "Leaderboard":
                box 20, 10, 260, 50
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
                characters "Leaderboard"
            group "Table":
                box 0, 70, 300, 585
                orgBox 0, 70, 300, 585
                constraints cMin,cStretch
                rectangle "Rectangle 6":
                    box 0, 41, 300, 40
                    constraints cMin, cMin
                    fill "#d7ba56"
                    cornerRadius 0
                    strokeWeight 1
                text "Sum":
                    box 0, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Sum"
                text "Score1":
                    box 100, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters $game.getLeaderboard().sum[1]
                text "Score2":
                    box 200, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters $game.getLeaderboard().sum[2]
                text "Player1":
                    box 100, 1, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Player 1"
                text "Player2":
                    box 200, 1, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Player 2"
                rectangle "hline":
                    box 0, 40, 300, 2
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "hline":
                    box 0, 80, 300, 2
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "vline1":
                    box 99, 0, 2, 585
                    constraints cMin, cStretch
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "vline2":
                    box 199, 0, 2, 585
                    constraints cMin, cStretch
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                text "Match":
                    box 0, 1, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "Match"
                frame "tableContent":
                    box 0,82,300,500
                    constraints cMin,cStretch
                    drawLeaderboard()
        if gameStarted:
            drawInfo()
        else:
            drawSettings()
                
drawMain = drawMainFrame
startFidget()