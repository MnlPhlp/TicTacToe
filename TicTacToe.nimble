# Package

version       = "1.0"
author        = "Manuel Philipp"
description   = "a special version of TicTacToe with various game modes"
license       = "MIT"
srcDir        = "src"
bin           = @["TicTacToe"]


# Dependencies

requires "nim >= 0.19.4"
requires "karax >= 1.1.0"

task karax, "build karax client":
  exec "cp website/TicTacToe.html docs/play/index.html"
  exec "cp website/style.css docs/play/style.css"
  exec "nim js -o:docs/play/TicTacToe.js src/karax_client"

task cli, "build comandline client":
  exec "nim c -o:cli_client src/cli_client.nim"

task debug_cli, "build commandline client for debugging":
  exec "nim c --debugger:native -o:debug_cli src/cli_client.nim"
