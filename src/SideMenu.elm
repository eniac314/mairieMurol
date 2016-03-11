module SideMenu where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Dict exposing (..)
import UrlParsing exposing (getTitle)
import TiledMenu exposing (init,view,update,Action)

-- Model

type alias Model = 
  { title      : String
  , current    : String
  , entries    : List String
  , contentMap : Dict String Content
  }

type Content = Doc Html | Menu (Maybe Html, TiledMenu.Model)

init : String -> String -> List String -> List (String,Content) -> Model
init title current entries contentList = 
    Model title current entries (Dict.fromList contentList)

initAt : String -> String -> String -> List String -> List (String,Content) -> Model
initAt title current urlParams entries contentList =
  let contentMap = Dict.fromList contentList
      altCurrent = (getTitle urlParams)
       
  in case (Dict.get altCurrent contentMap) of
      Nothing -> Model title current entries contentMap
      Just _ ->
        Model title altCurrent entries contentMap

-- Update
type Action = 
      NoOp
    | Entry String
    | TiledMenuAction (TiledMenu.Action)



update : Action -> Model -> Model
update action model = 
  case action of
    NoOp    -> model
    Entry s -> {model | current = s}
    TiledMenuAction act ->
        case (Dict.get (.current model) (.contentMap model)) of 
            Nothing -> model
            Just (Menu (c,tiledMenu)) -> 
                let newMenu = TiledMenu.update act tiledMenu
                    newContentMap = Dict.update
                                     (.current model)
                                     (\_ -> Just (Menu (c,newMenu)))
                                     (.contentMap model)
                in { model | contentMap = newContentMap }
            Just _ -> model




-- View
view : Signal.Address Action -> Model -> Html
view address model = 
    case (Dict.get (.current model) (.contentMap model)) of 
        Nothing -> nullTag
        Just (Menu (intro, tiledMenu)) -> 
            div [id "subContainer"]
                [ renderSideMenu address model
                , div [ class "subContainerData"] 
                      [ Maybe.withDefault nullTag intro
                      , TiledMenu.view (Signal.forwardTo address TiledMenuAction) tiledMenu
                      ]
                ]
        Just (Doc c) -> 
            div [id "subContainer"]
                [ renderSideMenu address model
                , c 
                ]


renderSideMenu : Signal.Address Action -> Model -> Html 
renderSideMenu address model =
  let title = .title model
      es    = .entries model 
      pos   = .current model
      isCurrent e = classList [("submenuCurrent", e == pos)]
      toA e = a [id e, onClick address (Entry ( removeSpecialChars e)), href "#", isCurrent e]
                [text e]
      linkList = List.map toA es
  in
  div [ class "sideMenu"]
      [ h3  [] [text (title)]
      , div [] linkList
      ]

-- Utils
maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

menuToContent : TiledMenu.Model -> Content
menuToContent m = Menu (Nothing, m)

menuWithContextToContent : TiledMenu.Model -> Html ->Content
menuWithContextToContent m c = Menu (Just c,m)

htmlToContent : Html -> Content
htmlToContent h = Doc h

removeSpecialChars : String -> String
removeSpecialChars input =
  let replacements = 
        Dict.fromList
          [('é','e')
          ,('è','e')
          ,('ç','c')
          ,('à','a')
          ,('â','a')
          ,('û','u')
          ,('ê','e')
          ,('ô','o')
          ,('î','i')
          ]
      replace c = 
        case (Dict.get c replacements) of
          Nothing -> c
          Just c' -> c'
  in String.map replace input      

