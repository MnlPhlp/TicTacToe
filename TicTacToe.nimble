# Package

version       = "0.1.0"
author        = "Manuel Philipp"
description   = "a special version of TicTacToe with various game modes"
license       = "MIT"
srcDir        = "src"
bin           = @["TicTacToe"]


# Dependencies

requires "nim >= 0.19.4"
requires "karax >= 1.1.0"

task custom_build, "custom build task":
  exec "nim js -o:website/TicTacToe.js src/karax_client"