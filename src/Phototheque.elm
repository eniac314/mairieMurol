module Phototheque where

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
      [ renderMainMenu' ["Culture et loisirs", "Phototheque"]
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
       div [ class "subContainerData noSubmenu", id "phototheque"]
           [ phototheque
           , content])
  , tiledMenu = initWithLink 
    [( "Paysages, printemps, été"
      , ""
      , [ 
        ]
      , "/PrintempsEte.html"
      )
    ,( "Paysages, automne, hiver"
      , ""
      , [ 
        ]
      , "/AutomneHiver.html"
      )
    ,( "Patrimoine"
      , ""
      , [ 
        ]
      , ""
      )

    ,( "Les Médiévales"
      , ""
      , [ 
        ]
      , ""
      )
    
    ,( "Murol fait sa révolution"
      , ""
      , [ 
        ]
      , ""
      )
    ,( "Le Festival d'Art"
      , ""
      , [ 
        ]
      , ""
      )

    ,( "La journée des Murolais"
      , ""
      , [ 
        ]
      , ""
      )
    ,( "Diaporama 2015"
      , ""
      , [ 
        ]
      , ""
      )
    ,( "Année 2016"
      , ""
      , [ 
        ]
      , ""
      )
     ]
  }

-- Data

phototheque = 
  div []
      [ h2 [] [text "La Phototheque"]
      , p  [] [text "Vous souhaitez partager vos plus belles photos de Murol ?
                     Transmettez-les au webmaster, elles doivent être libres de
                     droit. Le webmaster se réserve le droit d’accepter ou non les
                     photos proposées selon les règles de parution en vigueur*"
              ]
      ]