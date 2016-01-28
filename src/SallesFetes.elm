module SallesFetes where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (init,view,update,Action)
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
subMenu : Murol.Submenu
subMenu = { current = "", entries = []}

type alias MainContent = 
  { wrapper : (Html -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Murol.Menu
  , subMenu     : Murol.Submenu
  , mainContent : MainContent
  }  

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }



-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Mairie", "Salles municipales"]
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
       div [ class "subContainerData noSubmenu", id "sallesFetes"]
           [ h2 [] [text "Location des salles municipales"]
           , content])
  , tiledMenu =
      init [( "Salle des fêtes de Murol"
            , ""
            , [ 
              ]
            )
            ,
            ( "Salle des fêtes de Beaune"
            , ""
            , [
              ]
            )
           ]
  }


-- Data
