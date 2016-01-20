module UrlParsing where
import String exposing (words, join, cons, uncons)

getTitle : String -> String
getTitle urlParams = 
  case (String.uncons urlParams) of
    Nothing -> ""
    Just ('?', rest) -> parseParams (putSpaces rest)
    Just _ -> ""


parseParams : String -> String
parseParams stringWithAmpersands =
  let
    eachParam = (String.split "&" stringWithAmpersands)
    eachPair  = List.map (splitAtFirst '=') eachParam
  in case (List.head eachPair) of 
    Nothing -> ""
    Just ("bloc", s) -> s
    Just _ -> ""
    


splitAtFirst : Char -> String -> (String, String)
splitAtFirst c s =
  case (firstOccurrence c s) of
    Nothing -> (s, "")
    Just i  -> ((String.left i s), (String.dropLeft (i + 1) s))


firstOccurrence : Char -> String -> Maybe Int
firstOccurrence c s =
  case (String.indexes (String.fromChar c) s) of
    []        -> Nothing
    head :: _ -> Just head

putSpaces : String -> String
putSpaces xs = 
  let xs' = String.split "%20" xs
  in String.join " " xs'