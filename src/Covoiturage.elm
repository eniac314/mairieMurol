module Covoiturage where

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
  div [ class "subContainerData", id "initCovoit"]
      [ h2 [] [text "Le covoiturage"]
      , p  [] [ text "Le concept du covoiturage est vraiment très simple 
                      ! Au lieu que chacun utilise sa voiture 
                      pour effectuer des trajets quotidiens ou ponctuels, le 
                      covoiturage vous permet d'utiliser une voiture pour plusieurs 
                      personnes. Cela permet évidement de réduire les coûts 
                      de transport (prix de l'essence, usure de la 
                      voiture, ...), la pollution, les temps de transport. "]
     , h5 [] [ text "L'aspect économique"]
     , p [] [ text "En effet, le covoiturage vous permettra de diminuer 
                    largement vos frais liés à vos trajets en 
                    voiture (essence, usure de la voiture, ...). Dans 
                    le cas d'un covoiturage alterné (plusieurs conducteurs qui 
                    conduisent par alternance) vous pourrez diviser vos frais 
                    de trajet par autant de conducteur qui participe 
                    au covoiturage. Dans le cas d'un covoiturage avec 
                    participation (Les passagers participent financièrement aux trajets), là 
                    encore on observera une nette diminution des frais 
                    engendrés par l'utilisation de votre voiture. "]
       , h5 [] [ text "Un geste pour l'écologie"]
       , p [] [ text "Le covoiturage est une pratique qui permet de 
                      diminuer significativement le nombre de voiture circulant sur 
                      les routes. La première conséquence est la diminution 
                      de la pollution et de l'émission des gaz 
                      à effet de serre. Ceci permet également la 
                      diminution de consommation d'énergie non renouvelable comme le 
                      pétrole. "]
       , h5 [] [ text "Créer ou trouver un trajet, suivez les liens ci-dessous"]
       , p [] [ link "http://www.covoiturageauvergne.net" "http://www.covoiturageauvergne.net"]
       , p [] [ link "http://www.covoiturage.fr/" "http://www.covoiturage.fr/"]
       ]