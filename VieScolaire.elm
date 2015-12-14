module VieScolaire where

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
                       renderSubMenu)

-- Model
subMenu = [ "Ecole Maternelle"
          , "Ecole Elementaire"
          , "Le Secondaire"
          , "Periscolaire"
          ]

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ renderSubMenu address "Vie Scolaire:" (.subMenu model)
            , .mainContent model
            ]
      , pageFooter
      ]

-- Update

contentMap =
 fromList [ ("Ecole Maternelle",mater)
          , ("Ecole Elementaire", elem)
          , ("Le Secondaire", second)
          , ("Periscolaire", peri)
          ]

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

-- Miscs

nullTag = span [style [("display","none")]] []

initialContent = nullTag
mater  = nullTag
elem   = nullTag
second = nullTag
peri   = nullTag
