module MurolInfos where

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

type alias Category =
  { title   : String
  , entries : List Entry
  }

type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address
                       ["Documentation", "Murol Infos"]
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

initialContent = murolInf

-- Data
murolInf =
  div [class "subContainerData noSubmenu", id "murolInfPubli"]
      [ h2 [] [text "Murol info"]
      , h5 [] [text "2008"]
      , ul []
           [ li [] [link "Numero 01 - Avril" "http://www.murol.fr/Murol_info/01.pdf"]
           , li [] [link "Numero 02 - Mai" "http://www.murol.fr/Murol_info/02.pdf"]
           , li [] [link "Numero 03 - Juin" "http://www.murol.fr/Murol_info/03.pdf"]
           , li [] [link "Numero 04 - Septembre" "http://www.murol.fr/Murol_info/04.pdf"]
           , li [] [link "Numero 05 - Décembre" "http://www.murol.fr/Murol_info/05.pdf"]
           ]
      , h5 [] [text "2009"]
      , ul []
           [ li [] [link "Numero 05 - Février" "http://www.murol.fr/Murol_info/06.pdf"]
           , li [] [link "Numero 07 - Mai" "http://www.murol.fr/Murol_info/07.pdf"]
           , li [] [link "Numero 08 - Septembre" "http://www.murol.fr/Murol_info/08.pdf"]
           , li [] [link "Numero 09 - Décembre" "http://www.murol.fr/Murol_info/09.pdf"]
           ]     
      , h5 [] [text "2010"]
      , ul []
           [ li [] [link "Numero 10 - Août" "http://www.murol.fr/Murol_info/10.pdf"]
           , li [] [link "Numero 11 - Octobre" "http://www.murol.fr/Murol_info/11.pdf"]
           , li [] [link "Numero 12 - Décembre" "http://www.murol.fr/Murol_info/12.pdf"]
           ]
      , h5 [] [text "2011"]
      , ul []
           [ li [] [link "Numero 13 - Avril" "http://www.murol.fr/Murol_info/13.pdf"]
           , li [] [link "Numero 14 - Mai" "http://www.murol.fr/Murol_info/14.pdf"]
           , li [] [link "Numero 15 - Août" "http://www.murol.fr/Murol_info/15.pdf"]
           , li [] [link "Numero 16 - Octobre" "http://www.murol.fr/Murol_info/16.pdf"]
           ]
      , h5 [] [text "2013"]
      , ul []
           [ li [] [link "Numero 17 - Juin" "http://www.murol.fr/Murol_info/17.pdf"]
           , li [] [link "Numero 18 - Novembre" "http://www.murol.fr/Murol_info/18.pdf"]
           ]
      , h5 [] [text "2014"]
      , ul []
           [ li [] [link "Numero 19 - Avril" "http://www.murol.fr/Murol_info/19.pdf"]
           , li [] [link "Numero 20 - Mai" "http://www.murol.fr/Murol_info/20.pdf"]
           , li [] [link "Numero 21 - Juin" "http://www.murol.fr/Murol_info/21.pdf"]
           , li [] [link "Numero 22 - Octobre" "http://www.murol.fr/Murol_info/22.pdf"]
           , li [] [link "Numero 23 - Décembre" "http://www.murol.fr/Murol_info/23.pdf"]
           ]
      , h5 [] [text "2015"]     
      , ul []
           [ li [] [link "Numero 24 - Mai" "http://www.murol.fr/Murol_info/24.pdf"]
           , li [] [link "Numero 25 - Juin" "http://www.murol.fr/Murol_info/25.pdf"]
           , li [] [link "Numero 26 - Septembre" "http://www.murol.fr/Murol_info/26.pdf"]
           , li [] [link "Numero 27 - Novembre" "http://www.murol.fr/Murol_info/27.pdf"]
           ]
      , h5 [] [text "2016"]     
      , ul []
           [li [] [link "Numero 28 - Janvier" "baseDocumentaire/MUROL INFOS 28.doc"]
           ]
      ]
