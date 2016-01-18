module CartePlan where

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
      [ renderMainMenu address ["Tourisme", "Carte & Plan"]
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
  div [  class "subContainerData noSubmenu", id "CartePlan"]
      [  h2 [] [text "Carte & Plan"]
       , h3 [] [text "Accès"]
       , p [] [ text "Coordonnées : Latitude / longitude N 45°34'34\" / E 002°56'34\" "]
       , p [] [ text "UTM : 31T 0495538 5046689 "]
       , p [] [a [href "/Transports.html?bloc=Dessertes de la commune"] [text "les dessertes de la commune"]]
       , p [] [ text "Situer Murol en cliquant sur la carte"]
       , iframe [ id "map", src "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2792.828421278047!2d2.9417002157517658!3d45.57388887910252!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDXCsDM0JzI2LjAiTiAywrA1NiczOC4wIkU!5e0!3m2!1szh-TW!2stw!4v1449889280943"] []
       , h3 [] [ text "Infos routes"]
       , iframe [id "infoRoute", src "http://www.inforoute63.fr/index.php"] []
      ]