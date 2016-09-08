import System.Directory
import System.IO
import Data.List
import Control.Monad
--import qualified Text.Show.Pretty as Pr

path = "./images/photothèque"

addPath s = path ++ "/" ++ s

isNotDots s = s /= "." && s /= ".."

isNotRef s = s /= "referencePage"

isDirectory s =
 do p1 <- doesDirectoryExist.addPath $ s
    return (isNotDots s && p1)

isFile s = 
    do p1 <- doesFileExist s
       return (isNotDots s && isNotRef s && p1)

getPicsName p = 
  do setCurrentDirectory p
     ref <- readFile "referencePage"
     ctns <- getDirectoryContents "."
     files <- filterM isFile ctns
     setCurrentDirectory ".."
     return ((p,reverse.tail.reverse $ ref),files)     

hPrettyList [] h = hPutStrLn h "[]" 
hPrettyList xs h =
 do hPutStr h "["
    mapM (hPutStrLn h) (liner xs) 
    hPutStrLn h " ]"
 
 where liner []  = [] 
       liner [e] = [" " ++ show e]
       liner (e:es) = (" " ++ show e ++ ", ") : liner es

expand ((p,r),xs) = map (\e -> (e,p,r)) xs

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