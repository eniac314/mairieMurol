module GestionDesDechets where

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
      [ renderMainMenu address (.mainMenu model)
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
  div [ class "subContainerData"]
      [ link "Informations concernant la taxe d'enlèvement des ordures ménagère"
             "http://www.murol.fr/Base_documentaire/SICTOM/Informationsaugmentationtaxes.pdf"
        , text "2014"
        , h6 [ class "trashCat"] [ text "Ramassage des ordures"]
        , p  [] [ text "Le ramassage des ordures a lieu le: "]
        , ul []
             [ li [] [text "lundi pour les ordures ménagères"]
             , li [] [text "le mercredi pour le tri sélectif \"poubelles jaunes\""]
             ]
        , h6 [ class "trashCat"] [ text "Objets encombrants"]
        , p  [] [ text "La municipalité souhaite aider les personnes n’ayant pas 
                        les moyens matériels nécessaires pour évacuer leurs objets 
                        encombrants en organisant des ramassages groupés."]
        , p [] [ text "Pour vous inscrire, merci de téléphoner à la mairie
                       au 04 73 88 60 67, afin que la municipalité puisse
                       programmer un ramassage dès que les demandes seront suffisantes."]
        , h6 [ class "trashCat"] [ text "Déchets verts"]
        , p  [] [ text "Les déchets verts (tontes, branches et même troncs débités)
                        doivent être apportés au SICTOM DES COUZES à St Diéry."]
        , p  [] [ text "Ils ne doivent pas être déposés ni brûlés sur le site de  RABACHOT."]
        , h6 [ class "trashCat"] [ text "Déchèteries"]
        , p  [] [ text "La plus proche est celle de Besse"]
        , ul []
             [ li [] [text "Fermée jeudi et dimanche"]
             , li [] [text "Lundi mercredi vendredi et samedi : 9h-12h / 14h-18h"]
             , li [] [text "Mardi : 8h-12h / 14h/17h"]
             ]
        , p [] [text "Autre possibilité : la déchèterie de Montaigut le Blanc"]
        , ul []
             [ li [] [text "Fermée lundi et dimanche"]
             , li [] [text "Mardi au samedi : 9h-12h / 14h-18"]
             ]
        , h6 [ class "trashCat"] [ text "La collecte des déchets recyclables"]
        , p  [] []
      ]