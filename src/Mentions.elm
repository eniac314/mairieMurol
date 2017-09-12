module Mentions where

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
      [ renderMainMenu ["", ""]
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
  div [ class "subContainerData noSubmenu", id "mentions"]
      [ h2 [] [text "Mentions légales"]
      , div []
            [ p [] 
                [ h5 [] [text "Conception"]
                , text "Gillard Informatique"
                , br [] []
                , a  [target "_blank", href "http://www.gillardinformatique.net"]
                     [text "www.gillardinformatique.net"]
                , br [] []
                , br [] []
                , text "5 Place de l'église"
                , br [] []
                , text "89520 Lainsecq"
                , br [] []
                , text "Tel +33 (0)3 86 74 72 64"
                , br [] []
                , text "Mobile +33 (0)6 52 11 05 72"
                , br [] []
                , text "florian.gillard@gmail.com"
                , br [] []
                , text "Siret: 823 705 009 00020"
                ]
            , hr [] []
            , text "Hébergement: LWS France"
            , h5 [] [text "Données personnelles"]
            , p [] 
                [text """ Les données personnelles collectées par ce site 
                          sont uniquement destinées
                          à un usage interne. En aucun cas ces données ne seront
                          cédées, communiquées ou vendues à des tiers.
                      """
                ]
            ]
      ]
      

-- Data
