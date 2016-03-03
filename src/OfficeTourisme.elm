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
      [ h2 [] [ text "Office de Tourisme communautaire du massif du Sancy"]
      , img [src "/images/OT.JPG", id "officePic"] []
      , div [ id "infoOfficeTourisme"]
            [ h5 [] [text "Adresse:"]
            , p []
                [ text "Rue de jassaguet - 63790 Murol"]
            , p []
                [ text "Tel: 04 73 88 62 62"]
            , p []
                [ text "Fax : 04 73 88 60 23"]
            , mail "bt.murol-chambon@sancy.com"
            , br [] []
            , site "www.sancy.com" "www.sancy.com"
            , h5 [] [text "Horaires:"]
            , ul []
                 [ li [] [text "pendant les vacances, ouvert du lundi au samedi de 9h à 12h et de 14h à 18h"]
                 , li [] [text "le reste de l’année, ouvert du lundi au samedi de 9h à 12h."]
                 ]
            ]
      --, p [id "officeDescr"] 
      --    [b [] [text "Murol bénéficie des services de l’Office de Tourisme communautaire
      --                 de la communauté de communes du Massif du Sancy."]]      
      , h5 [id "officeDescr"] [text "Le bureau de Murol propose :"]
      , ul []
           [ li [] [ text "un ", b [] [text "accueil multilingue"] ]
           , li [] [ text "des ", b [] [text "documentations"], text " en libre-service sur les visites,
                     activités et les hébergements dans le massif du Sancy et au-delà"]
           , li [] [ text "un ", b [] [text "coin enfant"], text " pour faire patienter
                     les bambins (label Famille Plus)" ]
           , li [] [ text "Une connexion ", b [] [text "internet en wifi"]]
           , li [] [ text "Un service ", b [] [text "boutique"], text " avec les cartes
                           et topoguides de randonnées"]
           , li [] [ text "Un service de ", b [] [text "billetterie"]]
           , li [] [ text "un ", b [] [text "accueil adapté aux personnes handicapées : "]
                   , text "le bureau de tourisme est équipé d'un "
                   , b [] [text "Kit Accueil Comfort Duett "]
                   , text "(amplificateur de sons individuels adapté à toutes
                           personnes malentendantes). Il dispose d'une "
                   , b [] [text "documentation en caractères agrandis "]
                   , text "pour les personnes malvoyantes et ", b [] [text "en braille "]
                   , text "pour les personnes aveugles, ainsi que d’un ", b [] [text "micro "]
                   , text "pour enregistrer la conversation. Au moins un membre du personnel
                           d’accueil a suivi une formation spécifique à l’accueil des personnes
                           handicapées (label Tourisme et Handicap)."
                   ]                 
           ]  
      , renderListImg logos
      ]