module MurolInfos where

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

chunk n xs = 
  case xs of 
    []  -> []
    xs' -> (List.take n xs') :: chunk n (drop n xs')

sortDate xs = concat (reverse (chunk 2 xs)) 

murolInf =
  div [class "subContainerData noSubmenu", id "murolInfPubli"]
      ([ h2 [] [text "Murol info"]] ++ sortDate 
      [ h5 [] [text "2008"]
      , ul []
           [ li [] [link "Numero 01 - Avril" "/baseDocumentaire/murolInfo/01.pdf"]
           , li [] [link "Numero 02 - Mai" "/baseDocumentaire/murolInfo/02.pdf"]
           , li [] [link "Numero 03 - Juin" "/baseDocumentaire/murolInfo/03.pdf"]
           , li [] [link "Numero 04 - Septembre" "/baseDocumentaire/murolInfo/04.pdf"]
           , li [] [link "Numero 05 - Décembre" "/baseDocumentaire/murolInfo/05.pdf"]
           ]
      , h5 [] [text "2009"]
      , ul []
           [ li [] [link "Numero 05 - Février" "/baseDocumentaire/murolInfo/06.pdf"]
           , li [] [link "Numero 07 - Mai" "/baseDocumentaire/murolInfo/07.pdf"]
           , li [] [link "Numero 08 - Septembre" "/baseDocumentaire/murolInfo/08.pdf"]
           , li [] [link "Numero 09 - Décembre" "/baseDocumentaire/murolInfo/09.pdf"]
           ]     
      , h5 [] [text "2010"]
      , ul []
           [ li [] [link "Numero 10 - Août" "/baseDocumentaire/murolInfo/10.pdf"]
           , li [] [link "Numero 11 - Octobre" "/baseDocumentaire/murolInfo/11.pdf"]
           , li [] [link "Numero 12 - Décembre" "/baseDocumentaire/murolInfo/12.pdf"]
           ]
      , h5 [] [text "2011"]
      , ul []
           [ li [] [link "Numero 13 - Avril" "/baseDocumentaire/murolInfo/13.pdf"]
           , li [] [link "Numero 14 - Mai" "/baseDocumentaire/murolInfo/14.pdf"]
           , li [] [link "Numero 15 - Août" "/baseDocumentaire/murolInfo/15.pdf"]
           , li [] [link "Numero 16 - Octobre" "/baseDocumentaire/murolInfo/16.pdf"]
           ]
      , h5 [] [text "2013"]
      , ul []
           [ li [] [link "Numero 17 - Juin" "/baseDocumentaire/murolInfo/17.pdf"]
           , li [] [link "Numero 18 - Novembre" "/baseDocumentaire/murolInfo/18.pdf"]
           ]
      , h5 [] [text "2014"]
      , ul []
           [ li [] [link "Numero 19 - Avril" "/baseDocumentaire/murolInfo/19.pdf"]
           , li [] [link "Numero 20 - Mai" "/baseDocumentaire/murolInfo/20.pdf"]
           , li [] [link "Numero 21 - Juin" "/baseDocumentaire/murolInfo/21.pdf"]
           , li [] [link "Numero 22 - Octobre" "/baseDocumentaire/murolInfo/22.pdf"]
           , li [] [link "Numero 23 - Décembre" "/baseDocumentaire/murolInfo/23.pdf"]
           ]
      , h5 [] [text "2015"]     
      , ul []
           [ li [] [link "Numero 24 - Mai" "/baseDocumentaire/murolInfo/24.pdf"]
           , li [] [link "Numero 25 - Juin" "/baseDocumentaire/murolInfo/25.pdf"]
           , li [] [link "Numero 26 - Septembre" "/baseDocumentaire/murolInfo/26.pdf"]
           , li [] [link "Numero 27 - Novembre" "/baseDocumentaire/murolInfo/27.pdf"]
           ]
      , h5 [] [text "2016"]     
      , ul []
           [ li [] [link "Numero 28 - Janvier" "baseDocumentaire/murolInfo/28.pdf"]
           , li [] [link "Numero 29 - Avril" "baseDocumentaire/murolInfo/29.pdf"]
           , li [] [link "Numero 30 - Juin" "baseDocumentaire/murolInfo/30.pdf"]
           , li [] [link "Numero 31 - Juillet" "baseDocumentaire/murolInfo/31.pdf"]
           , li [] [link "Numero 32 - Novembre" "baseDocumentaire/murolInfo/32.pdf"]
           ]
      , h5 [] [text "2017"]     
      , ul []
           [ li [] [link "Numero 33 - Mai" "baseDocumentaire/murolInfo/33.pdf"]
           , li [] [link "Numero 34 - Juin" "baseDocumentaire/murolInfo/34.pdf"]
           , li [] [link "Numero 35 - Septembre" "baseDocumentaire/murolInfo/34.pdf"]
           ]
      ])
