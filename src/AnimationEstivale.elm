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
      [ p [] [text "La saison estivale 2016 est terminée, retrouvez nous
                   dès le printemps prochain pour notre nouvelle programmation."]
      --, p [] [text "La saison estivale arrive avec de nombreuses animations!"]
      --, p [] [text "Découvrez le programme des mois de juillet et août 2016: "]
      --, a [href "/baseDocumentaire/animation/programme1.pdf", target "_blank"]
      --    [text "programme 4-16 juillet"]
      --, br [] []
      --, a [href "/baseDocumentaire/animation/programme2.pdf", target "_blank"]
      --    [text "programme 17-31 juillet"]
      --, br [] []
      --, a [href "/baseDocumentaire/animation/programme3.pdf", target "_blank"]
      --    [text "programme 31 juillet - 12 août"]
      --, br [] []
      --, a [href "/baseDocumentaire/animation/programme4.pdf", target "_blank"]
      --    [text "programme 14 - 31 août"]
      --, p [] [text "Ainsi que le déroulement de la journée du 14 Juillet:"]
      --, a [href "/baseDocumentaire/animation/affiche14juillet2016.pdf", target "_blank"]
      --    [text "programme 14 juillet"]
      , br [] []
      , img [src "/images/illustration animations estivales.jpg"] []
      ]