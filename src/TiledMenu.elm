module TiledMenu where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import UrlParsing exposing (getTitle)
import Dict exposing (..)


-- Model

type alias Model = 
  { current   : ContentType
  , menuData  : Dict ID (Tile,Html)
  , photoLink : Bool
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
  in Model Menu (Dict.fromList xs') False

initAt : String -> List (String,String,List Html) -> Model
initAt urlParams xs = 
  let title =  getTitle urlParams
      model = init xs
      maybeId = getByTitle title model
  in case maybeId of 
    Nothing -> model
    Just id -> update (ShowTile id) model 

initAtPhoto : String -> List (String,String,List Html) -> Model
initAtPhoto urlParams xs = 
  let title =  getTitle urlParams
      model = initPhoto xs
      maybeId = getByTitle title model
  in case maybeId of 
    Nothing -> model
    Just id -> update (ShowTile id) model 

initAtWithLink : String -> List (String,String,List Html,String) -> Model
initAtWithLink urlParams xs = 
  let title =  getTitle urlParams
      model = initWithLink xs
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
  in Model Menu (Dict.fromList xs') False

initPhoto : List (String,String,List Html) -> Model
initPhoto xs =
  let n = List.length xs
      zip = List.map2 (,)
      xs' = List.map (\((t,p,c),id) ->
                       (id
                       , (Tile t id p Nothing,div [] (h4 [] [text t]::c))
                       )
                     ) (zip xs [0..n])
  in Model Menu (Dict.fromList xs') True

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
                    picture' = if String.isEmpty picture
                               then "/images/tiles/hebergements/placeholder.jpg"
                               else picture
                    htmlTile = 
                      a attr
                        [ figure []
                                 [ img [src picture'] []
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
              , if (.photoLink model)
                then a [ href "/Photothèque.html", id "photoLink" ]
                       [ text "Photothèque"]
                else nullTag
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
  in case List.head ids of 
       Nothing  -> Result.toMaybe (String.toInt s) 
       Just res -> Just res
  
