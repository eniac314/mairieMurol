module Publications where

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
subMenu = [ "Délibération conseil municipal"
          , "Murol info"
          , "Bulletin municipal"
          , "Reportages à Murol"
          , "Elections"
          , "Divers"
          ]

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ renderSubMenu address "Publications:" (.subMenu model)
            , .mainContent model
            ]
      , pageFooter
      ]

-- Update

contentMap =
 fromList [("Délibération conseil municipal",delib)
          ,("Murol info",murolInf)
          ,("Bulletin municipal",bulletin)
          ,("Reportages à Murol",reportages)
          ,("Elections",elections)
          ,("Divers",divers)
          ]

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
  div [ class "subContainerData", id "publications"]
      [delib]

      

-- Data
delib = 
  div [class "subContainerData", id "delibPubli"]
      [ h5 [] [text "2014"]
      , ul []
           [ li [] [link "19 mars" "http://www.murol.fr/Deliberations_conseil/2014/19032014.pdf"]
           , li [] [link "4 avril" "http://www.murol.fr/Deliberations_conseil/2014/04042014.pdf"]
           , li [] [link "10 avril" "http://www.murol.fr/Deliberations_conseil/2014/10042014.pdf"]
           , li [] [link "16 juillet" "http://www.murol.fr/Deliberations_conseil/2014/16072014.pdf"]
           , li [] [link "28 oct" "http://www.murol.fr/Deliberations_conseil/2014/28102014.pdf"]
           , li [] [link "22 dec" "http://www.murol.fr/Deliberations_conseil/2014/22122014.pdf"]
           ]
      , h5 [] [text "2015"]
      , ul []
           [ li [] [link "12 février" "http://www.murol.fr/Deliberations_conseil/2015/CM12022015.pdf"]
           , li [] [link "19 mars" "http://www.murol.fr/Deliberations_conseil/2015/CM19032015.pdf"]
           , li [] [link "15 avril" "http://www.murol.fr/Deliberations_conseil/2015/CM15042015.pdf"]
           , li [] [link "2 juin" "http://www.murol.fr/Deliberations_conseil/2015/CM24092015.pdf"]
           , li [] [link "4 novembre" "http://www.murol.fr/Deliberations_conseil/2015/CM04112015.pdf"]
           ]
      ]

murolInf =
  div [class "subContainerData", id "murolInfPubli"]
      []

bulletin =
  div [class "subContainerData", id "bullPubli"]
      []

reportages = 
  div [class "subContainerData", id "repoPubli"]
      []

elections = 
  div [class "subContainerData", id "elecPubli"]
      []

divers = 
  div [class "subContainerData", id "diversPubli"]
      []
