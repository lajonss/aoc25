beam = 'S'

free = '.'

splitter = '^'

isBeam character = character == beam

isFree character = character == free

isSplitter character = character == splitter

doesSplit (previousCharacter, currentCharacter) = isBeam previousCharacter && isSplitter currentCharacter

getNextCharacter left (previous, current) right =
  if isBeam current || (isFree current && (doesSplit left || isBeam previous || doesSplit right))
    then (beam, splits)
    else (free, splits)
  where
    splits = isSplitter current && isBeam previous

getNextLine :: [(Char, Char)] -> [Char] -> Int -> ([Char], Int)
getNextLine joinedLines nextLine splitsCount =
  case take 3 joinedLines of
    [a, b, c] -> getNextLine (drop 1 joinedLines) (nextLine ++ [nextCharacter]) (splitsCount + (if splits then 1 else 0))
      where
        (nextCharacter, splits) = getNextCharacter a b c
    _ -> (nextLine, splitsCount)

joinLines previous current = [(free, free)] ++ zip previous current ++ [(free, free)]

parseLines :: [Char] -> [[Char]] -> Int -> Int
parseLines line lines splitsCount =
  case lines of
    [] -> splitsCount
    (h : t) -> parseLines' line h t splitsCount

parseLines' line linesHead linesTail splitsCount =
  parseLines nextLine linesTail splitsCountSum
  where
    (nextLine, splitsCountSum) = getNextLine (joinLines line linesHead) [] splitsCount

main = do
  input <- getContents
  let inputLines = lines input
  print (parseLines (head inputLines) (tail inputLines) 0)
