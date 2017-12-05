module ContactMairie where

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


type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu []
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
  div [  class "subContainerData noSubmenu", id "CartePlan"]
      [  h2 [] [text "Contacter le webmaster"]
      , iframe [ src "contact.html"
               , id "contactIframe" 
             --, width 
               , height 800  
               , attribute "frameborder" "0" --(Json.Encode.string "0")
               --, attribute "scrolling" "no"
               --, attribute "onload" "resizeIframe(this);"
               --, attribute "allowfullscreen" "true"--(Json.Encode.string "true")
              , style [ ("width", "100%")
                      --, ("height","100%")
                      --, ("overflow","hidden")
                      --, ("max_height","200px")
                      ]
            ]
            []
      ]