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
      ([ h2 [] [text "Délibération conseil municipal"]] ++ sortDate
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
           , li [] [link "2 juin" "/baseDocumentaire/Deliberations_conseil/2015/CM24092015.pdf"]
           , li [] [link "4 novembre" "/baseDocumentaire/Deliberations_conseil/2015/CM04112015.pdf"]
           , li [] [link "3 décembre" "/baseDocumentaire/Deliberations_conseil/2015/03-12-2015.pdf"]
           ]
      ])