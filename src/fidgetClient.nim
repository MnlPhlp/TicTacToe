import fidget,os

when not defined(js):
    import typography,tables
    fonts["IBM Plex Sans Regular"] = readFontSvg(getAppDir() & "/data/IBMPlexSans-Regular.svg")
    fonts["IBM Plex Sans Bold"] = readFontSvg(getAppDir() & "/data/IBMPlexSans-Bold.svg")


proc drawMainFrame() =
    frame "Frame 1":
        when not defined(js):
            box root.box
        else:
            box 0, 0, 1280, 720
        constraints cMin, cMin
        fill "#ffffff"
        fill "#ffffff"
        cornerRadius 0
        strokeWeight 1
        group "Heading":
            box 400, 20, 480, 60
            rectangle "Rectangle 1":
                box 0, 0, 480, 60
                constraints cCenter, cMin
                fill "#d7ba56"
                cornerRadius 30
                strokeWeight 1
            text "Tic-Tac-Toe":
                box 0, 0, 480, 60
                constraints cMin, cMin
                fill "#000000"
                strokeWeight 1
                stroke color(0,1,0)
                font "IBM Plex Sans Bold", 48, 200, 0, 0, 0
                characters "Tic-Tac-Toe"
        frame "GameFrame":
            box 335, 90, 610, 610
            constraints cScale, cScale
            cornerRadius 0
            strokeWeight 1
            rectangle "Rectangle 2":
                box 0, 0, 610, 610
                constraints cBoth, cBoth
                fill "#c4c4c4"
                cornerRadius 0
                strokeWeight 1
            rectangle "Rectangle 3":
                box 5, 5, 600, 600
                constraints cBoth, cBoth
                fill "#eeeeee"
                cornerRadius 0
                strokeWeight 1
            frame "Game":
                box 5, 5, 600, 600
                constraints cMin, cMin
                cornerRadius 0
                strokeWeight 1
        frame "Leaderboard":
            box 960, 40, 300, 655
            constraints cMax, cBoth
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
                    characters "0"
                text "Score2":
                    box 200, 41, 100, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "0"
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
                    constraints cMin, cMax
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "vline1":
                    box 99, 0, 2, 585
                    constraints cMin, cBoth
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "vline2":
                    box 199, 0, 2, 585
                    constraints cMin, cBoth
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
        frame "Settings":
            box 20, 40, 300, 655
            constraints cMin, cBoth
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
                font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
                characters "Settings"
            group "SettingButtons":
                box 45, 360, 200, 50
                rectangle "startButton":
                    box 0, 0, 200, 50
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 25
                    strokeWeight 1
                text "start":
                    box 0, 0, 200, 50
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 36, 200, 0, 0, 0
                    characters "start"
            group "P2Name":
                box 0, 155, 276, 40
                text "Player 2:":
                    box 0, 0, 120, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
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
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "enter Name"
            group "P1Name":
                box 0, 110, 276, 40
                text "Player 1:":
                    box 0, 0, 120, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
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
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "enter Name"
            group "FieldSize":
                box 0, 225, 265, 40
                text "Field Size:":
                    box 0, 0, 130, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
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
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "3"
                frame "MinField":
                    box 145, 5, 30, 30
                    constraints cMin, cMin
                    fill "#ffffff"
                    fill "#ffffff"
                    cornerRadius 0
                    strokeWeight 1
                rectangle "Rectangle 8":
                    box 0, -207.5, 5, 30
                    constraints cMin, cMin
                    fill "#c4c4c4"
                    cornerRadius 0
                    strokeWeight 1
                frame "plusField":
                    box 235, 5, 30, 30
                    constraints cMin, cMin
                    fill "#ffffff"
                    fill "#ffffff"
                    cornerRadius 0
                    strokeWeight 1
                    rectangle "Rectangle 7":
                        box 12.5, -225, 5, 30
                        constraints cMin, cMin
                        fill "#c4c4c4"
                        cornerRadius 0
                        strokeWeight 1
                    rectangle "Rectangle 8":
                        box 0, -207.5, 5, 30
                        constraints cMin, cMin
                        fill "#c4c4c4"
                        cornerRadius 0
                        strokeWeight 1
            group "Win Count":
                box 0, 270, 265, 40
                text "Win Count:":
                    box 0, 0, 130, 40
                    constraints cMin, cMin
                    fill "#000000"
                    strokeWeight 1
                    font "IBM Plex Sans Regular", 24, 200, 0, -1, 0
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
                    font "IBM Plex Sans Regular", 24, 200, 0, 0, 0
                    characters "3"
                frame "MinField":
                    box 145, 5, 30, 30
                    constraints cMin, cMin
                    fill "#ffffff"
                    fill "#ffffff"
                    cornerRadius 0
                    strokeWeight 1
                    rectangle "Rectangle 8":
                        box 0, -252.5, 5, 30
                        constraints cMin, cMin
                        fill "#c4c4c4"
                        cornerRadius 0
                        strokeWeight 1
                    frame "plusField":
                        box 235, 5, 30, 30
                        constraints cMin, cMin
                        fill "#ffffff"
                        fill "#ffffff"
                        cornerRadius 0
                        strokeWeight 1
                        rectangle "Rectangle 7":
                            box 12.5, -270, 5, 30
                            constraints cMin, cMin
                            fill "#c4c4c4"
                            cornerRadius 0
                            strokeWeight 1
                        rectangle "Rectangle 8":
                            box 0, -252.5, 5, 30
                            constraints cMin, cMin
                            fill "#c4c4c4"
                            cornerRadius 0
                            strokeWeight 1
                    
drawMain = drawMainFrame
startFidget()