import 
  game_logic,
  strutils,
  strformat,
  turn_based_game

include karax / prelude


let game = new(GameOfTicTacToe)
var setup = false
var message = kstring""
let settings = new(Settings)


proc inputHandler(ev: Event, n: VNode) =
  case $n.id:
    of "name1":
      settings.name1 = $n.value
    of "name2":
      settings.name2 = $n.value
    of "AI":
      settings.ai = n.value == "true"

proc startGame()=
  game.setup(settings)
  system.echo($settings.name1)
  setup = false

proc clickField(ev: Event, n: VNode) =
  #make the move
  discard game.make_move($n.id)

proc setupGUI(): VNode =
  buildHtml(tdiv):
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
  buildHtml(tdiv):
    tdiv(id="status"):
      text message
    tdiv(class = "grid-container"):
      for i,line in game.field:
          for j,field in line:
              #create button-grid as field
              button(class = "grid-item", id=fmt"{i}{j}", onclick = clickField):
                text desc[field]
    tdiv(class="command_buttons"):
      button(class = "start"):
        text "start"
        proc onclick() =
          setup = true
      button(class = "reset", id = "reset"):
        text "reset"


proc createDom(): VNode =
  if setup:
    setupGUI()
  else:
    playGUI()
    
setRenderer createDom

