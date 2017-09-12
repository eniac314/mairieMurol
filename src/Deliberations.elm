module Deliberations where

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
                       mail,
                       site,
                       link)

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu
                       ["Mairie", "Délibérations"]
                       (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]



update action model =
  case action of
    _       -> model


--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent = delib
  
-- Data
chunk n xs = 
  case xs of 
    []  -> []
    xs' -> (List.take n xs') :: chunk n (drop n xs')

sortDate xs = concat (reverse (chunk 2 xs)) 

delib = 
  div [class "subContainerData noSubmenu", id "delibPubli"]
      ([ h2 [] [text "Délibérations conseil municipal"]] ++ sortDate
      [ h5 [] [text "2014"]
      , ul []
           [ li [] [link "19 mars" "/baseDocumentaire/Deliberations_conseil/2014/19032014.pdf"]
           , li [] [link "4 avril" "/baseDocumentaire/Deliberations_conseil/2014/04042014.pdf"]
           , li [] [link "10 avril" "/baseDocumentaire/Deliberations_conseil/2014/10042014.pdf"]
           , li [] [link "16 juillet" "/baseDocumentaire/Deliberations_conseil/2014/16072014.pdf"]
           , li [] [link "28 oct" "/baseDocumentaire/Deliberations_conseil/2014/28102014.pdf"]
           , li [] [link "22 dec" "/baseDocumentaire/Deliberations_conseil/2014/22122014.pdf"]
           ]
      , h5 [] [text "2015"]
      , ul []
           [ li [] [link "12 février" "/baseDocumentaire/Deliberations_conseil/2015/CM12022015.pdf"]
           , li [] [link "19 mars" "/baseDocumentaire/Deliberations_conseil/2015/CM19032015.pdf"]
           , li [] [link "15 avril" "/baseDocumentaire/Deliberations_conseil/2015/CM15042015.pdf"]
           , li [] [link "10 juin" "/baseDocumentaire/Deliberations_conseil/2015/CM24092015.pdf"]
           , li [] [link "24 septembre" "/baseDocumentaire/Deliberations_conseil/2015/24-09-2015.pdf"]
           , li [] [link "4 novembre" "/baseDocumentaire/Deliberations_conseil/2015/CM04112015.pdf"]
           , li [] [link "3 décembre" "/baseDocumentaire/Deliberations_conseil/2015/03-12-2015.pdf"]
           ]
      , h5 [] [text "2016"]
      , ul []
           [ li [] [link "17 février" "/baseDocumentaire/Deliberations_conseil/2016/17fev2016.pdf"]
           , li [] [link "17 mars" "/baseDocumentaire/Deliberations_conseil/2016/17mars2016.pdf"]
           , li [] [link "14 avril" "/baseDocumentaire/Deliberations_conseil/2016/14avr2016.pdf"]
           , li [] [link "16 juin" "/baseDocumentaire/Deliberations_conseil/2016/16juin2016.pdf"]
           , li [] [link "12 juillet" "/baseDocumentaire/Deliberations_conseil/2016/12jui2016.pdf"]
           , li [] [link "12 octobre" "/baseDocumentaire/Deliberations_conseil/2016/12oct2016.pdf"]
           , li [] [link "7 novembre" "/baseDocumentaire/Deliberations_conseil/2016/07nov2016.pdf"]
           , li [] [link "28 novembre" "/baseDocumentaire/Deliberations_conseil/2016/28nov2016.pdf"]
           , li [] [link "5 décembre" "/baseDocumentaire/Deliberations_conseil/2016/05dec2016.pdf"]
           , li [] [link "13 décembre" "/baseDocumentaire/Deliberations_conseil/2016/13dec2016.pdf"] 
           ]
      , h5 [] [text "2017"]
      , ul []
           [ li [] [link "17 janvier" "/baseDocumentaire/Deliberations_conseil/2017/17jan2017.pdf"]
           , li [] [link "1 février" "/baseDocumentaire/Deliberations_conseil/2017/01fev2017.pdf"]
           , li [] [link "13 mars" "/baseDocumentaire/Deliberations_conseil/2017/13mar2017.pdf"] 
           , li [] [link "11 avril" "/baseDocumentaire/Deliberations_conseil/2017/11Avr2017.pdf"] 
           , li [] [link "15 juin " "/baseDocumentaire/Deliberations_conseil/2017/15Juin2017.pdf"] 
           , li [] [link "30 juin" "/baseDocumentaire/Deliberations_conseil/2017/30Juin2017.pdf"] 
           ]
      ])