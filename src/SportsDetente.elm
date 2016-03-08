module SportsDetente where

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

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Culture et loisirs","Sports et détente"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

-- Update

contentMap =
 fromList []

update action model =
  case action of
    NoOp    -> model
    _       -> model



--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  div [ class "subContainerData noSubmenu", id "sportsDetente"]
      [ h4 [] [text "Activité : YOGA"]
      , p  [] [text "Des séances de Yoga hebdomadaires sont mises en place dans l'enceinte
                     du centre Lignerat ou thermadore à St Nectaire tous les vendredis à 19h00."]
      , p [] [text "Tarif : 10€ le cours d'une heure et demie. "]               
      , p [] [text "renseignements sur place ou Association \"Créons Demain \""]
      , p [] [text "Contact : "]
      , p [] [text "Tél : 06 86 325 346 "]
      , p [] [text "Mail  : isavey@wanadoo.fr"]
      , p [] [text "Professeur : Isabelle Chassaniol"]

      
      , h4 [] [text "Rugby tennis de table"]
      , h4 [] [text "Qi gong gymnastique"]
      , h4 [] [text "Ski de fond et raquettes"]
      , h4 [] [text "Tennis multisports"]
      , h4 [] [text "terrain de pétanque"]
      ]