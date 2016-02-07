module Animaux where

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


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Vie locale", "Animaux"]
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
  div [ class "subContainerData noSubmenu", id "animaux"]
      [ h2 [] [text "Animaux"]
      , p  [] [text "Vous avez trouvé ou perdu un animal, contacter"]
      , p  [] [text "SOS Animaux"]
      , p  [] [text "La Prade 63500 Le Broc"]
      , p  [] [text "Tél :04 7371 6243 ou 06 1328 0895"]
      , p  [] [text "Heures d'ouverture:"]
      , p  [] [text "14h00 à 17h00 du lundi au samedi inclus sauf jours fériés"]
      , p  [] [text "Référent local : Anne-Marie DOTTE tél : 06 8100 2032"]
      ]
      

-- Data
