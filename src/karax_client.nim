import 
  game_logic,
  strutils,
  strformat,
  karax / kdom

include karax / prelude


let game = new(GameOfTicTacToe)
var state = 0
var message = kstring"Welcome"
let settings = new(Settings)


proc inputHandler(ev: Event, n: VNode) =
  case $n.id:
    of "name1":
      settings.name1 = $n.value
    of "name2":
      settings.name2 = $n.value
    of "AI":
      settings.ai = ($n.value == "on")

proc startGame()=
  game.setup(settings)
  state = 2


proc clickField(ev: Event, n: VNode) =
  #make the move
  message = game.make_turn($n.id)
  

proc setupGUI(): VNode =
  buildHtml(tdiv(class = "center")):
    tdiv(class = "settings"):
      label:
        text "Player 1: "
        input(placeholder="name 1", id="name1", onchange = inputHandler)
        br()
      label:
        text "Player 2: "
        input(placeholder="name 2" ,id="name2", onchange = inputHandler)
      label:
        text "AI"
        input(type="checkbox", id="AI", onchange=inputHandler)
        br()
      label:
        text "Field size: "
        input(id="field_size")
        br()
      button(onclick=startGame):
        text "start Game"
      

proc playGUI():VNode =
  buildHtml(tdiv(class = "center")):
    tdiv(id="status"):
      text message
    #tdiv(id="current player"):
     # text "test"#game.getPlayer
    tdiv(class = "grid-container"):
      for i,line in game.field:
          for j,field in line:
              #create button-grid as field
              button(class = "grid-item", id=fmt"{i+1}{j+1}", onclick = clickField,
               disabled = kstring(toDisabled(state==0 or field != 0 or game.finished))):
                text desc[field]
    tdiv(class="command_buttons"):
      button(class = "start"):
        text "setup"
        proc onclick() =
          state = 1 
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
      if settings.name1 == "" or settings.name2 == "":
        window.alert("fill out player names")
        state = 1
        result = setupGUI()
      else:
        result = playGUI()
    else:
      discard

setRenderer createDom

