import Data.List

type Link = [Char]

type Int' = [Int]

data Menu = Link String | Node ([Int])

a :: Menu
a = Node [12,2]

b :: Menu
b = Link "test"

cutter :: Int -> [String] -> [String]
cutter n [] = ["\n"]
cutter n xs = 
    let (h,t) = splitAt n xs
    in (h ++ ["\n"])++cutter n t  

main = interact $ concat . map (unwords . (cutter 8) . words) . lines