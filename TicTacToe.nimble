# Package

version       = "1.0"
author        = "Manuel Philipp"
description   = "a special version of TicTacToe with various game modes"
license       = "MIT"
srcDir        = "src"
bin           = @["TicTacToe"]


# Dependencies

requires "nim >= 0.19.4",
  "karax >= 1.1.0",
  "turn_based_game",
  "negamax"

task karax, "build karax client":
  exec "cp website/Karax.html docs/play/Karax.html"
  exec "cp website/style.css docs/play/style.css"
  exec "nim js -o:docs/play/Karax.js src/karax_client"

task fidgetWeb, "build fidget web client":
  selfExec "js -o:docs/play/Fidget.js src/fidgetClient.nim"
  exec "cp website/Fidget.html docs/play/Fidget.html"

task fidget, "build fidget desktop client":
  selfExec "c -o:fidgetClient -d:release src/fidgetClient.nim"

task cli, "build comandline client":
  exec "nim c -o:cli_client src/cli_client.nim"

task debug_cli, "build commandline client for debugging":
  exec "nim c --debugger:native -o:debug_cli src/cli_client.nim"
