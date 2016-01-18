module OfficeTourisme where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Murol exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       Action (..),
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }


type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Tourisme", "Office de Tourisme"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]



contentMap =
 fromList []

update action model =
  case action of
    NoOp    -> model
    Entry s -> changeMain model s
    _       -> model

changeMain model s =
    let newContent = get s contentMap
    in case newContent of
        Nothing -> model
        Just c  -> { model | mainContent = c }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  div [ class "subContainerData noSubmenu", id "officeTourisme"]
      [ h2 [] [ text "Office de tourisme"]
      , p []
          [ text "Rue de jassaguet - 63790 Murol"]
      , p []
          [ text "Tel: 04-73-88-62-62"]
      , p []
          [ text "Fax : 04-73-88-60-23"]
      , mail "bt.murol-chambon@sancy.com"
      , ul []
           [ h5 [] [text "Horaires:"]
           , li [] [text "pendant les vacances, ouvert du lundi au samedi de 9h à 12 et de 14h à 18h."]
           , li [] [text "Le reste de l’année, ouvert du lundi au samedi de 9h à 12h."]
           ]
      , renderListImg logos
      ]