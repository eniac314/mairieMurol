module TiledMenu where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Dict exposing (..)


-- Model

type alias Model = 
  { current  : ContentType
  , menuData : Dict ID (Tile,Html)
  }

type alias Tile =
  { title : String
  , iD : ID
  , picture : String
  , link : Maybe String 
  }

type ContentType = Menu | Content Html
type alias ID = Int 

init : List (String,String,List Html) -> Model
init xs =
  let n = List.length xs
      zip = List.map2 (,)
      xs' = List.map (\((t,p,c),id) ->
                       (id
                       , (Tile t id p Nothing,div [] (h4 [] [text t]::c))
                       )
                     ) (zip xs [0..n])
  in Model Menu (Dict.fromList xs')

initAt : String -> List (String,String,List Html) -> Model
initAt urlParams xs = 
  let title =  getTitle urlParams
      model = init xs
      maybeId = getByTitle title model
  in case maybeId of 
    Nothing -> model
    Just id -> update (ShowTile id) model 

initWithLink : List (String,String,List Html,String) -> Model
initWithLink xs = 
  let n = List.length xs
      zip = List.map2 (,)
      xs' = List.map (\((t,p,c,l),id) ->
                       let l' = if String.isEmpty l then Nothing else Just l
                       in
                       (id
                       , (Tile t id p l',div [] (h4 [] [text t]::c))
                       )
                     ) (zip xs [0..n])
  in Model Menu (Dict.fromList xs')

-- Update
type Action = 
       ShowTile Int
     | ShowMenu 

update : Action -> Model -> Model
update action model = 
    case action of 
        ShowTile id ->
          let (_,newContent) =
                 Maybe.withDefault
                  (nullTile,nullTag)
                  (Dict.get id model.menuData)
          in
             { model | current = Content newContent }
        
        ShowMenu ->
            { model | current = Menu }

-- View
view : Signal.Address Action -> Model -> Html
view address model =
    case model.current of 
        Menu -> 
          let toDivs _ (tile,_) acc =
                let {title,iD,picture,link} = tile
                    attr =
                     case link of
                      Nothing -> [class "tile"
                                 , href "#"
                                 , id "tiledMenuTop"
                                 , onClick address (ShowTile iD)
                                 ]
                      Just l  -> [class "tile"
                                 , href l
                                 , id "tiledMenuTop"
                                 ]
                    htmlTile = 
                      a attr
                        [ figure []
                                 [ img [src picture] []
                                 , div [class "captionWrapper"]
                                       [figcaption [] [text title]]
                                 ]
                        ]

                in htmlTile :: acc

              tiles = Dict.foldr toDivs [] (model.menuData)
          in 
              div [ class "tiledMenu" ]
                  tiles

        Content selCont -> 
          div [ class "selected"]
              [ selCont 
              , a [ href "#tiledMenuTop", onClick address ShowMenu, id "backToTiledMenu" ]
                  [ text "Revenir au menu" ]
              ]



-- Utils
maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTile = Tile "" 0 "" Nothing
nullTag = span [style [("display","none")]] []

getByTitle : String -> Model -> Maybe ID
getByTitle s m = 
  let d' = Dict.filter (\k (t,_) -> .title t == s)  (.menuData m)
      ids = Dict.keys d'
  in List.head ids
  
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