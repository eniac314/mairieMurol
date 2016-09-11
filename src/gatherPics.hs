import System.Directory
import System.IO
import Data.List
import Control.Monad

path = "./images/photothèque"

addPath :: String -> String
addPath s = path ++ "/" ++ s

isNotDots :: String -> Bool
isNotDots s = s /= "." && s /= ".."

isNotRef :: String -> Bool
isNotRef s = s /= "referencePage"

isDirectory :: String -> IO Bool
isDirectory s =
 do p1 <- doesDirectoryExist.addPath $ s
    return (isNotDots s && p1)

isFile :: String -> IO Bool
isFile s = 
    do p1 <- doesFileExist s
       return (isNotDots s && isNotRef s && p1)

-- for a given folder returns the associated html page and all the pictures
getPicsName :: FilePath -> IO ((FilePath, String), [FilePath])
getPicsName p = 
  do setCurrentDirectory p
     ref <- readFile "referencePage"
     ctns <- getDirectoryContents "."
     files <- filterM isFile ctns
     setCurrentDirectory ".."
     return ((p,reverse.tail.reverse $ ref),files)     

-- pretty prints  a list in file corresponding to handle h
hPrettyList :: Show a => [a] -> Handle -> IO ()
hPrettyList [] h = hPutStrLn h "[]" 
hPrettyList xs h =
 do hPutStr h "["
    mapM (hPutStrLn h) (liner xs) 
    hPutStrLn h " ]"
 
 where liner []  = [] 
       liner [e] = [" " ++ show e]
       liner (e:es) = (" " ++ show e ++ ", ") : liner es

expand :: ((t1, t2), [t]) -> [(t, t1, t2)]
expand ((p,r),xs) = map (\e -> (e,p,r)) xs

main :: IO ()
main = do sd <- getCurrentDirectory
          ctns <- getDirectoryContents path
          direc <- filterM isDirectory ctns 
          setCurrentDirectory path
          names <- mapM getPicsName direc
          let names2 = concat $ map expand names
          --putStrLn (show names2) 
          setCurrentDirectory (sd ++ "/src")
          
          handle <- openFile "ListOfPics.elm" WriteMode
          hPutStrLn handle "module ListOfPics where"
          hPutStrLn handle ""
          hPutStrLn handle "import Dict exposing (..)"
          
          hPutStrLn handle ""
          hPutStr handle "picList = "
          hPrettyList names handle

          hPutStrLn handle ""
          hPutStr handle "picList2 = "
          hPrettyList names2 handle 

          hClose handle

          setCurrentDirectory sd

          return ()