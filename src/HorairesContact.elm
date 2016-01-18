module HorairesContact where

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
      [ renderMainMenu address
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
  div [ class "subContainerData noSubmenu", id "horairesEtContact"]
      [ h2 [] [text "Contacter la mairie"]     
      , div []
        [ figure []
                 [img [src "/images/Mairie.jpg"] []]
        , h5 [] [text "Par courrier:"]
        , p  [] [text "Mairie de Murol - Place de l'hôtel de ville - 63790 Murol"]
        , h5 [] [text "Par téléphone :"]
        , p  [] [text "04 73 88 60 67 / Fax : 04 73 88 65 03 "]
        , h5 [] [text "Par mail:"]
        , mail "mairie.murol@wanadoo.fr"
        , h5 [] [text "Horaires d'ouverture:"]
        , p  [] [text "du lundi au vendredi : 9h à 12h30 / 13h30 à 17h"]
        , p  [] [text "Permanence maire/adjoints samedi matin"]
        
        , h5 [] [text "Location de salles des fêtes municipales"]
        , p  [] [text "La commune dispose de 3 salles polyvalentes.
                       2 situés sur le bourg de Murol et la 3ème sur le bourg de Beaune le froid."]
        , p  [] [text "Ces salles sont mises à la location au tarif de 150€ la journée pour vos évènements"]
        , p  [] [text "Elles restent à disposition à titre gracieux pour les murolais."]
        ]
      ]

      

-- Data
