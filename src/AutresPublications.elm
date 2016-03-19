module AutresPublications where

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

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu ["Documentation","Autres publications"]
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
  div [ class "subContainerData noSubmenu", id "autresPubli"]
      [ h2 [] [text "Autres publications"]
      , link "Note de synthèse 2012 station classée de tourisme" "/baseDocumentaire/Notedesynthèse Murol 2012.pdf"
      , link "Présention du chateau de Murol par Dominique Allios" "/baseDocumentaire/decouvrirMurol/presentationAllios.pdf"
      , link "Les volcans du Tartaret - Pierre Lavina" "/baseDocumentaire/decouvrirMurol/tartaretLavina.pdf"
      ]