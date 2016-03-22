module OffresEmploi where

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
      [ renderMainMenu ["Vie économique", "Offres d'emploi"] (.mainMenu model)
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

initialContent =
  div [ class "subContainerData", id "offresEmploi"]
      [ h4 [] [text "Offres emploi de la mairie"]
      , p  []
           [ a [href "/baseDocumentaire/offresEmploi/offre animateur saison estivale 2016.pdf", target "_blank"]
               [text "offre animateur saison estivale 2016"]
           ]
      , p  []
           [ a [href "/baseDocumentaire/offresEmploi/offre responsable  animation 2016.pdf", target "_blank"]
               [text "offre responsable animation 2016"]
           ]
      , p  []
           [ a [href "/baseDocumentaire/offresEmploi/offre surveillants de baignade 2016.pdf", target "_blank"]
               [text "offre surveillants de baignade 2016"]
           ]
      , p  []
           [ a [href "/baseDocumentaire/offresEmploi/offre responsable des surveillants de baignade 2016.pdf", target "_blank"]
               [text "offre responsable des surveillants de baignade 2016"]
           ]
      , p  []
           [ a [href "/baseDocumentaire/offresEmploi/offre agents entretien mairie 2016.pdf", target "_blank"]
               [text "offre agents entretien mairie 2016"]
           ]
      --, p  []
      --     [ a [href "/baseDocumentaire/offresEmploi/", target "_blank"]
      --         [text ""]
      --     ]
       
      , h4 [] [text "Offres emploi SIVOM"]
      , p  []
           [ a [href "/baseDocumentaire/offresEmploi/offres sivom de la vallée verte  2016.pdf", target "_blank"]
               [text "offres sivom de la vallée verte 2016"]
           ]
      
      , h4 [] [text "Offres emploi professionnels"]
      , h4 [] [text "Liens utiles"]
      , p  [] [text "Pôle emploi: ", a [href "http://www.pole-emploi.fr", target "_blank"]
                                       [text "Lien"]]
      , p  [] [text "Relais Saisonniers Sancy: ", a [href "http://www.lerelais-saisonniers-sancy.org/", target "_blank"]
                                                    [text "Lien"]]
      ]
      

-- Data
