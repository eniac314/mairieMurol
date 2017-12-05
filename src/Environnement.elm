module Environnement where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initAtWithLink,view,update,Action)
import StarTable exposing (makeTable, emptyTe, Label(..))
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu : Utils.Submenu
subMenu = { current = "", entries = []}

type alias MainContent = 
  { wrapper : (Html -> Bool -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Utils.Menu
  , subMenu     : Utils.Submenu
  , mainContent : MainContent
  , showIntro   : Bool
  }  

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  , showIntro   = if String.isEmpty locationSearch
                  then True
                  else False
  }

-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu ["Vie locale", "Environnement"] (.mainMenu model)
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

port locationSearch : String

initialContent =
  { wrapper = 
    (\content showIntro ->
       div [ class "subContainerData noSubmenu", id "periscolaire"]
           [ h2 [] [text "Environnement"]
           , content       
           ])
  , tiledMenu =
      initAtWithLink locationSearch anim
  }
--Data

anim =
  [ ("Gestion des déchets"
    ,"/images/tiles/environnement/dechets.jpg"
    , [ 
      ]
    ,"GestionDesDéchets.html"
    )
  ,("Gestion de l’eau"
    ,"/images/tiles/environnement/eau.jpg"
    , [ ul [] 
           [ li [] [ a [href "/baseDocumentaire/environnement/GUIDE SIVU.pdf", target "_blank"]
                       [text "guide du SIVU"]
                   ]
           , li [] [ a [href "/baseDocumentaire/Note de présentation SIVU et contrat terrirorial.pdf", target "_blank"]
                       [text "présentation SIVU"]
                   ]
           ]
      ]
    ,""
    )
  ,("Gestion des espaces verts"
    ,"/images/tiles/environnement/espacesVerts.jpg"
    , [ ul [] 
           [ li [] [ a [href "/VillageFleuri.html"]
                       [text "page ville et village fleuris"]
                   ]
           , li [] [ a [href "/baseDocumentaire/CPDGSdecretarreteambroisies040517.pdf", target "_blank"]
                       [text "Communiqué de presse concernant la lutte contre les ambroisies"]
                   ]
           ]
      ]
    ,""
    )
  ,("Gestion des risques"
    ,"/images/tiles/environnement/risques.jpg"
    , [ 
      ]
    ,"GestionDesRisques.html"
    )
  ,("Charte de développement durable"
    ,"/images/tiles/environnement/devDurable.jpg"
    , [ ul [] 
           [ li [] [ a [ href "/baseDocumentaire/Charte de dvlpt durable diagnostic MUROL.pdf"
                       , target "_blank"
                       ]
                       [text "Charte de développement durable dans les stations de montagnes"]
                   ]
           ]
      ]
    ,""
    )
  ,("Milieux sensibles"
    ,"/images/tiles/environnement/millieuxSensibles.jpg"
    , [ ul [] 
           [ li [] [ a [href "/baseDocumentaire/livretLac.pdf", target "_blank"]
                       [text "Livret d'informations sur le lac Chambon"]
                   ]
           , li [] [ a [href "/baseDocumentaire/Dossier zone humide de Murol.pdf", target "_blank"]
                       [text "Projet zone humide"]
                   ]
           , li [] [ a [href "/baseDocumentaire/decouvrirMurol/tartaretLavina.pdf", target "_blank"]
                       [text "Lles volcans du Tartaret - Pierre Lavina"]
                   ]
           ]
      ]
    ,""
    ) 
  ]