module NumerosUrgences where

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

type alias Category =
  { title   : String
  , entries : List Entry
  }

type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu [] (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

catToTable : Category -> Html
catToTable cat =
  let t    = .title cat
      es   = .entries cat
      rows = 
        List.map 
          (\(a,b) ->
            tr [] [ td [class "telTitle" ] [text a]
                  , td [class "telNumber"] [text b]]) es 
  in 
  table [ id t]
        (th [colspan 2] [text t] :: rows)

urgenceDiv = 
  div [ id "tableUrgence"]
      [ catToTable secours
      , catToTable sante
      , catToTable enfance
      , catToTable couple
      , catToTable personnesAgees
      , catToTable divers
      , catToTable edf
      , catToTable eau
      , catToTable telecom
      ]

pratiqueDiv = 
  div [ id "tablePratique" ]
      [ catToTable services
      , catToTable publicServ
      , catToTable volPerteCarte
      , catToTable volPerteTel
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
  div [ class "subContainerData noSubmenu", id "urgence"]
      [ h2 [] [text "Numeros d'urgences"] 
      , urgenceDiv
      , pratiqueDiv
      ]
      

-- Data


-- Urgences
secours = 
  { title   = "Secours"
  , entries = 
      [ ("Pompiers","18")
      , ("Gendarmerie","17")
      , ("Gendarmerie de Besse","04 73 79 50 02")
      ]
  }

sante = 
  { title   = "Santé"
  , entries = 
      [ ("Pour toute urgence médicale SAMU","15")
      , ("numéro d'urgence européen (urgences médicales, incendies, police...)","112")
      , ("hébergement d'urgence","115")
      , ("Centre anti-poison Lyon","04 72 11 69 11")
      , ("Sida Info Service","0 800 840 800")
      , ("Drogue Info Service","0 800 231 313")
      , ("Pharmacie de garde","04 73 79 50 02")
      ]
  }

enfance = 
  { title   = "Enfance"
  , entries = 
        [ ("Antenne enfance maltraitée ou délaissée","119")
        , ("Fil santé jeunes","0 800 235 236")
        , ("Bizutage SOS violences","08 10 55 55 00")
        ]
  }

couple = 
  { title   = "Couple"
  , entries = 
        [ ("Violence conjugale","3919")
        ]
  }

personnesAgees = 
  { title   = "Personnes âgées"
  , entries = 
      [ ("Allo Maltraitance des personnes âgées ","08 92 68 01 18")
      , ("Association Française de protection et d'assistance aux personnes âgées","08 00 02 05 28")
      ]
  }  

divers = 
  { title   = "Divers"
  , entries = 
        [ ("Allo escroquerie","0 811 020 217")
        ]
  }

edf = 
  { title   = "EDF"
  , entries = 
        [ ("Dépannage électricité","0 810 333 063")
        ]
  }

eau = 
  { title   = "Lyonnaise des Eaux"
  , entries = 
        [ ("Urgence","0 810 843 843")
        ]
  }

telecom = 
  { title   = "France télécom"
  , entries = 
        [ ("Urgence","1013")
        ]
  }

-- Numeros pratiques
services = 
  { title   = "Services"
  , entries = 
      [ ("Météorologie Puy de dôme","0 836 680 2 63")
      , ("SNCF horaires et informations","0 836 676 869")
      , ("SNCF informations et réservations","0 836 353 535")
      , ("Horloge parlante","3699")
      ]
  }  

publicServ = 
  { title   = "Service public"
  , entries = 
      [ ("Service public renseignements administratifs","3939")
      , ("Mairie de Murol","04 73 88 60 67")
      ]
  }

volPerteCarte = 
  { title   = "Vol / Perte de carte bancaire ou chéquier"
  , entries = 
      [ ("Chéquiers","0 892 68 32 08")
      , ("Carte bleue et visa","0 892 70 57 05")
      , ("Carte premier","01 42 77 45 45")
      , ("Carte Diner's Club","01 47 62 75 75")
      , ("Carte Eurocard","01 45 67 53 53")
      , ("Carte American express","01 47 77 72 00")
      , ("SOS cartes perdues/volées groupement des cartes","0 892 69 08 80")
      ]
  }


volPerteTel = 
  { title   = "Vol / perte de votre téléphone mobile"
  , entries = 
      [ ("Bouygues","0 803 803 614")
      , ("Orange","0 800 14 20 14")
      , ("SFR","06 1000 1900")
      ]
  }  