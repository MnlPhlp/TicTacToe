import 
  strutils,
  strformat,
  karax / [kdom,vstyles],

  game_logic

include karax / prelude


let game = new(GameOfTicTacToe)
var state = 0
var message = kstring"Welcome"
let settings = new(Settings)


proc inputHandler(ev: Event, n: VNode) =
  case $n.id:
    of "name1":
      settings.name1 = if $n.value != "" : $n.value else: "player 1"
    of "name2":
      settings.name2 = if $n.value != "" : $n.value else: "player 2"
    of "AI":
      settings.ai = not settings.ai
    of "fieldSize":
      settings.size = if $n.value != "" : n.value.parseInt else: 3
    of "winCount":
      settings.winCount = if $n.value != "" : n.value.parseInt else: 3

proc startGame()=
  game.setup(settings)
  message = fmt"{game.getPlayerName}'s turn"
  state = 2


proc clickField(ev: Event, n: VNode) =
  #make the move
  message = game.make_turn($n.id)
  

proc setupGUI(): VNode =
  buildHtml(tdiv(class = "center settings")):
    tdiv(class="field"):
      label:
        text "Player 1: "
        input(class = "input",placeholder ="player 1", id="name1", onkeyup = inputHandler)
        br()
    tdiv(class="field"):
      label:
        text "Player 2: "
        input(placeholder="player 2" ,id="name2", onkeyup = inputHandler)
    label:
      text "AI"
      input(type="checkbox", id="AI", onClick = inputHandler)
      br()
    tdiv(class="field"):
      label:
        text "Field size: "
        input(id="fieldSize", placeholder = "3", onkeyup=inputHandler)
        br()
    tdiv(class="field"):
      label:
        text "line length to win: "
        input(id="winCount", placeholder = "3", onkeyup=inputHandler)
        br()
    button(onclick=startGame):
      text "start Game"
    

proc playGUI():VNode =
  var buttonStyle: VStyle
  if window.innerHeight > window.innerWidth:
    buttonStyle = style(
      (StyleAttr.width, kstring(fmt"calc(70vw/{game.size})")),
      (StyleAttr.height, kstring(fmt"calc(70vw/{game.size})")),
      (StyleAttr.lineHeight, kstring(fmt"calc(70vw/{game.size})")),
      (StyleAttr.fontSize, kstring(fmt"calc(70vw/{game.size})"))
    )
  else:
    buttonStyle = style(
      (StyleAttr.width, kstring(fmt"calc(70vh/{game.size})")),
      (StyleAttr.height, kstring(fmt"calc(70vh/{game.size})")),
      (StyleAttr.lineHeight, kstring(fmt"calc(70vh/{game.size})")),
      (StyleAttr.fontSize, kstring(fmt"calc(70vh/{game.size})"))
    )

  buildHtml(tdiv(class = "center")):
    p(id="status"):
      text message
    #tdiv(id="current player"):
    # text "test"#game.getPlayer
    if state == 2:
      table:
        for i,line in game.field:
          tr:
            for j,field in line:
              td:
                #create button-grid as field
                button(style = buttonStyle, class = "fieldButton", id=fmt"{i+1}{j+1}", onclick = clickField,
                disabled = kstring(toDisabled(state==0 or field != 0 or game.finished))):
                  text desc[field]
    tdiv(class="command_buttons"):
      button(class = "start"):
        text "setup"
        proc onclick() =
          state = 1 
          settings.setDefault()
      button(class = "reset", id = "reset"):
        text "reset"
        proc onclick() =
          game.setup(settings)


proc createDom(): VNode =
  case state:
    of 1:
      result = setupGUI()
    of 0:
      result = playGUI()
    of 2:
      result = playGUI()
    else:
      discard


setRenderer createDom

