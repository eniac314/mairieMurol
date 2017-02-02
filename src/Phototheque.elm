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
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       
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
  { mainMenu    : Utils.Menu
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
      [ renderMainMenu ["Culture et loisirs", "photothèque"]
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
       div [ class "subContainerData noSubmenu", id "photothèque"]
           [ photothèque showIntro
           , content])
  , tiledMenu = initWithLink 
    [( "Paysages, printemps, été"
      , "/images/tiles/photothèque/printempsEte.jpg"
      , [ 
        ]
      , "/PrintempsEte.html"
      )
    ,( "Paysages, automne, hiver"
      , "/images/tiles/photothèque/automneHiver.jpg"
      , [ 
        ]
      , "/AutomneHiver.html"
      )
    ,( "Patrimoine"
      , "/images/tiles/photothèque/patrimoine.jpg"
      , [ 
        ]
      , "/PatrimoinePhoto.html"
      )

    ,( "Les Médiévales"
      , "/images/tiles/photothèque/medievales.jpg"
      , [ 
        ]
      , "/Medievales.html"
      )
    
    ,( "Murol fait sa révolution"
      , "/images/tiles/photothèque/revolution.jpg"
      , [ 
        ]
      , "/14Juillet.html"
      )
    ,( "Le Festival d'Art"
      , "/images/tiles/photothèque/festivalArt.jpg"
      , [ 
        ]
      , "/FestivalArt.html"
      )

    ,( "La journée des Murolais"
      , "/images/tiles/photothèque/journeeMurolais.jpg"
      , [ 
        ]
      , "/JourneeMurolais.html"
      )
    ,( "Diaporama 2016"
      , "/images/tiles/photothèque/diaporama2016.jpg"
      , [ a [ target "_blank"
            , href "/baseDocumentaire/DIAPORAMA MUROL 2016.pdf"
            ]
            [ text "Télécharger le diaporama 2016"]
        , br [] []
        ]
      , ""
      )
    ,( "Année 2017"
      , "/images/tiles/photothèque/annee2017.jpg"
      , [ 
        ]
      , "/Annee2017.html"
      )
     ]
  }

-- Data

photothèque showIntro = 
  div []
      [ h2 [] [ text "La photothèque" ]
        , div [ classList [("intro",True),("displayIntro", showIntro)] ]
              [ p  []
                   [text "Vous souhaitez partager vos plus belles photos de Murol ?
                          Transmettez-les au webmaster, elles doivent être libres de
                          droit. Le webmaster se réserve le droit d’accepter ou non les
                          photos proposées selon les règles de parution en vigueur*"
                   ]
              , a  [href ""] [text "Règles de parution et de stockage"]
              , text " *(mise en ligne prochainement)"
              ]
        
      ]