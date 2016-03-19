module Entreprises where

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
      [ renderMainMenu
                       ["Vie économique","Entreprises"]
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
  div [ class "subContainerData noSubmenu", id "entreprises"]
      [ h2 [] [ text "Les entreprises"]
      , h4 [] [ text "Etudes et conseils"]
      , h5 [] [ text "L'expérience de l'art du bois"]
      , p  [] [ text "Agnès Bonnefoy"]
      , p  [] [ text "Consultant en batiment"]
      , p  [] [ text "2 rue de Chabrol - 63790 Murol"]
      , p  [] [ text "Tél : 04 7383 6552    Fax : 06 3824 3372"]
      , site "www.etudesetconseils.com" "www.etudesetconseils.com"
      , mail "agnesbonnefoy2@orange.fr"
      ]
      

-- Data
