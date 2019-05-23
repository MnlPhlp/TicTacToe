include ../src/game_logic

#######################################
##############  Testing    ############
#######################################
const testSize = 10
var testField: array[testSize, array[testSize,int]]
var tests: seq[array[testSize, array[testSize,int]]]
let allLines = getLines(testSize)
for line in allLines:
  for i in 0..testSize-1:
    for j in 0..testSize-1:
      testField[i][j] = 0
  for pos in line:
    testField[pos[0]][pos[1]] = 1
  tests.add(testField)

for line in tests:
  for example in line:
    echo $example
  echo ""
  echo "#############"
  echo ""

echo fmt"total posibilities: {allLines.len}"