module LesAdos where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       
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
      [ renderMainMenu
                       ["Mairie", "Horaires et contact"]
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
    Entry s -> changeMain model s

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
  div [ class "subContainerData noSubmenu", id "lesAdos"]
      [ h2 [] [text "Les ados"]     
      , div []
        [ p []
            [text "La municipalité et le CCAS de Murol ont mis en place le dispositif
                  \"argent de poche\" qui permet aux jeunes de 14 à 18 ans domiciliés
                  sur la commune de participer à des chantiers encadrés
                  durant les vacances scolaires."]
        , p [] [text "En contre-partie ils recevront une gratification."]
        , p [] [a [href "/baseDocumentaire/ados/Document d'information argent de poche.pdf", target "_blank"]
                  [text "Document information argent de poche"]
               ]
        , p [] [a [href "/baseDocumentaire/ados/Dossier d'inscription argent de poche.pdf", target "_blank"]
                  [text "Dossier inscription argent de poche"]
               ]
        , p [] [a [href "/baseDocumentaire/ados/plaquette printemps 2017 argent de poche.pdf", target "_blank"]
                  [text "Plaquette printemps 2017 argent de poche"]
               ]
        ]
      ]

      

-- Data
