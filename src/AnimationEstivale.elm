module AnimationEstivale where

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
      [ renderMainMenu ["Tourisme", "Animation estivale"]
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
  div [ class "subContainerData noSubmenu", id "animationEstivale"]
      --[ p [] [text "La saison estivale 2016 est terminée, retrouvez nous
      --             dès le printemps prochain pour notre nouvelle programmation."]
      [ p [] [text "La saison estivale arrive avec de nombreuses animations!"]
      , p [] [text "Découvrez le programme des mois de juillet et août 2017: "]
      , a [href "/baseDocumentaire/animation/programme 1 juillet 2017.pdf", target "_blank"]
          [text "programme 9 - 21 juillet"]
      , br [] []
      , a [href "/baseDocumentaire/animation/programme 2 juillet 2017.pdf", target "_blank"]
          [text "programme 23 juillet - 5 août"]
      , br [] []
      , a [href "/baseDocumentaire/animation/programme3 aout 2017.pdf", target "_blank"]
          [text "programme 6 - 18 août"]
      , br [] []
      , a [href "/baseDocumentaire/animation/programme 4 aout 2017.pdf", target "_blank"]
          [text "programme 20 août - 1 septembre"]

      , br [] []
      , br [] []
      , a [href "/baseDocumentaire/animation/expos estivales 2017.pdf", target "_blank"]
          [text "Les expos estivales 2017"]
      
      , p [] [text "Ainsi que le déroulement de la journée du 14 Juillet:"]
      , a [href "/baseDocumentaire/animation/affiche14juillet2017.pdf", target "_blank"]
          [text "programme 14 juillet"]
      , br [] []
      , br [] []
      , img [src "/images/illustration animations estivales.jpg"] []
      ]