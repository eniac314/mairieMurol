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
  { wrapper : (Html -> Bool -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Murol.Menu
  , mainContent : MainContent
  , showIntro   : Bool
  }  

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  , showIntro   = True
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
                (.showIntro model)
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
            showIntro = not (.showIntro model)
            , mainContent = 
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
    (\content showIntro ->
       div [ class "subContainerData noSubmenu", id "phototheque"]
           [ phototheque showIntro
           , content])
  , tiledMenu = initWithLink 
    [( "Paysages, printemps, été"
      , "/images/tiles/phototheque/printempsEte.jpg"
      , [ 
        ]
      , "/PrintempsEte.html"
      )
    ,( "Paysages, automne, hiver"
      , "/images/tiles/phototheque/automneHiver.jpg"
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
      , "/images/tiles/phototheque/festivalArt.jpg"
      , [ 
        ]
      , "/FestivalArt.html"
      )

    ,( "La journée des Murolais"
      , "/images/tiles/phototheque/journeeMurolais.jpg"
      , [ 
        ]
      , "/JourneeMurolais.html"
      )
    ,( "Diaporama 2015"
      , "/images/tiles/phototheque/diaporama2015.jpg"
      , [ a [ download True
            , href "/baseDocumentaire/DIAPORAMA MUROL 2015.pdf"
            ]
            [ text "Télécharger le diaporama 2015"]
        , br [] []
        ]
      , ""
      )
    ,( "Année 2016"
      , "/images/tiles/phototheque/annee2016.jpg"
      , [ 
        ]
      , "/Annee2016.html"
      )
     ]
  }

-- Data

phototheque showIntro = 
  div []
      [ h2 [] [ text "La Phototheque" ]
        , div [ classList [("intro",True),("displayIntro", showIntro)] ]
              [ p  []
                   [text "Vous souhaitez partager vos plus belles photos de Murol ?
                          Transmettez-les au webmaster, elles doivent être libres de
                          droit. Le webmaster se réserve le droit d’accepter ou non les
                          photos proposées selon les règles de parution en vigueur*"
                   ]
              , a  [href ""] [text "Règles de parution et de stockage"]
              ]
        
      ]