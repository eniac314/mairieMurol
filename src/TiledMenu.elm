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
  }

type ContentType = Menu | Content Html
type alias ID = Int 

init : List (String,String,List Html) -> Model
init xs =
  let n = List.length xs
      zip = List.map2 (,)
      xs' = List.map (\((t,p,c),id) ->
                       (id
                       , (Tile t id p,div [] (h4 [] [text t]::c))
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
                let {title,iD,picture} = tile
                    htmlTile = 
                        a   [class "tile"
                            , href "#"
                            , id "tiledMenuTop"
                            , onClick address (ShowTile iD)
                            ]
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
              , a [ href "#tiledMenuTop", onClick address ShowMenu ]
                  [ text "Revenir au menu" ]
              ]



-- Utils
maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTile = Tile "" 0 ""
nullTag = span [style [("display","none")]] []