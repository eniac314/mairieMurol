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
      , link "Charte de développement durable - préconisation" "/baseDocumentaire/charte de dvlpt durable préconisation Murol.pdf"
      , link "Charte de développement durable - diagnostic" "/baseDocumentaire/Charte de dvlpt durable diagnostic MUROL.pdf"
      , link "Document valtom compostage" "/baseDocumentaire/doc valtom compostage.pdf"
      , link "Note de synthèse 2012 station classée de tourisme" "/baseDocumentaire/Notedesynthèse Murol 2012.pdf"
      , link "Présention du chateau de Murol par Dominique Allios" "/baseDocumentaire/decouvrirMurol/presentationAllios.pdf"
      , link "Les volcans du Tartaret - Pierre Lavina" "/baseDocumentaire/decouvrirMurol/tartaretLavina.pdf"
      , link "Le c.o.d.e des lacs et rivières - 2015" "/baseDocumentaire/code_lacs_rivieres_2015_calameo.pdf"
      , link "Note de présentation SIVU" "baseDocumentaire/Note de présentation SIVU et contrat terrirorial.pdf"
      , link "Dossier zone humide de Murol" "baseDocumentaire/Dossier zone humide de Murol.pdf"
      , link "Fiche Organicité" "baseDocumentaire/ficheORGANICITE.pdf"
      , link "Fiche Organicité n°2" "baseDocumentaire/lettre OrganiCité n°2.pdf"
      , link "Livret d'informations sur le lac Chambon" "baseDocumentaire/livretLac.pdf"
      , link "Plaquette semaine parentalité" "baseDocumentaire/plaquette_semaineParentalite2016.pdf"
      , link "Communiqué de presse concernant la lutte contre les ambroisies" "baseDocumentaire/CPDGSdecretarreteambroisies040517.pdf"
      , link "Dossier de presse PAVILLON BLEU 2017" "/baseDocumentaire/PAVILLON BLEU dossier de presse 2017.pdf"
      ]