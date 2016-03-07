module Sortir where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initWithLink,view,update,Action)
import StarTable exposing (makeTable, emptyTe, Label(..))
import Murol exposing (mainMenu,
                       renderMainMenu',
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)


-- Model

type alias MainContent = 
  { wrapper : (Html -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Murol.Menu
  , mainContent : MainContent
  }  

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }



-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Culture et loisirs", "Sortir"]
                        (.mainMenu model)
      , div [ id "subContainer"]
            [ (.wrapper (.mainContent model))
               (TiledMenu.view (Signal.forwardTo address TiledMenuAction) (.tiledMenu (.mainContent model)))
            ]
      , pageFooter
      ]



-- Update

type Action =
    NoOp
  | TiledMenuAction (TiledMenu.Action)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp    -> model
    TiledMenuAction act ->
      let mc = (.mainContent model)
          tm = (.tiledMenu (.mainContent model))
      in
          { model | 
            mainContent = 
             { mc | tiledMenu = TiledMenu.update act tm }
          }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }


initialContent =
  { wrapper = 
    (\content ->
       div [ class "subContainerData noSubmenu", id "Sortir"]
           [ h2 [] [text "Sortir"]
           , content])
  , tiledMenu =
      initWithLink
            [("Musée des peintres"
            ,"/images/tiles/sortir/musee.jpg"
            ,[ 
             ]
            ,"http://www.musee-murol.fr/fr"
             )
            ,
            ("Château de Murol"
            ,"/images/tiles/sortir/chateau.jpg"
            ,[
             ]
            ,"www.chateaudemurol.fr"
             )
            ,
            ("Dans les environs"
            ,"/images/tiles/sortir/sortir environs.jpg"
            ,[
             ]
            ,""
             )
            ,
            ("Cinéma"
            ,"/images/tiles/sortir/salle cinema.jpg"
            ,[
             ]
            ,"http://www.sancy.com/agenda/cinema/besse-superbesse"
             )
            ]
  }

-- Data

