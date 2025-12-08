free = 0
splitter = -1

isFree character = character == free

isSplitter character = character == splitter

countSplit (previousValue, currentValue) =
    if isSplitter currentValue
        then previousValue
        else 0

getNextValue left (previous, current) right =
  if isSplitter current
    then free
    else previous + current + countSplit left + countSplit right

getNextLine joinedLines nextLine =
  case take 3 joinedLines of
    [a, b, c] -> getNextLine (drop 1 joinedLines) (nextLine ++ [nextValue])
      where
        nextValue = getNextValue a b c
    _ -> nextLine

joinLines previous current = [(free, free)] ++ zip previous current ++ [(free, free)]

parseCharacter character =
    case character of
        'S' -> 1
        '.' -> free
        '^' -> splitter

parseLine = map parseCharacter

parseLines line lines =
  case lines of
    [] -> sum line
    (h : t) -> parseLines' line h t

parseLines' line linesHead = parseLines $ getNextLine (joinLines line linesHead) []

main = do
  input <- getContents
  let inputLines = map parseLine (lines input)
  print $ parseLines (head inputLines) (tail inputLines)
