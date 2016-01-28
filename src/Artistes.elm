module Artistes where

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
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }


type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Culture et loisirs", "Artistes"]
                               (.mainMenu model)
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
  div [ class "subContainerData noSubmenu", id "artistes"]
      [ h2 [] [text "Artistes Murolais"]
      , h5 [] [text "Site Internet gratuit des \"Artistes Murolais Contemporains\":" ]
      , p  [] [text "Danielle lance l'idée d'un Site Internet gratuit des \"Artistes Murolais Contemporains\""]
      , p  [] [text "Peinture, dessin, poésie, sculpture, artisanat d'art, etc....."]
      , p  [] [text "vous êtes intéressés, contactez-la en utilisant les lien ci-dessous"]
      , p  [] [link "http://murol-terre-des-arts.wifeo.com" " http://murol-terre-des-arts.wifeo.com"]
      , p  [] [link "http://murolpoesicales.wifeo.com" "http://murolpoesicales.wifeo.com"]
      , p  [] [link "http://daniellaero.wifeo.com" "http://daniellaero.wifeo.com"]


      , h5 [] [text "Cath Cuir: "]
      , p  [] [text "Rue de Chabrol 63790 MUROL"]
      , p  [] [text "Tel: 0611891452"]
      , p  [] [text "Ouvert de juin à août "] 

      , h4 [] [text "Création d'un orchestre"]
      , p  [] [text "Madame Marie-Laure Franc, chef d'orchestre, cherche des musiciens pour créer un orchestre dans notre région."]
      , p  [] [text "Je suis chef d'orchestre et je cherche des 
                     musiciens pour créer un orchestre dans notre région. 
                     Le projet est de faire quelques concerts par 
                     an en soutien aux associations humanitaires. Je fais 
                     ça à titre bénévole, ne demande aucune participation 
                     financière, mais simplement musicale dans une ambiance conviviale, 
                     pour développer les activités artistiques dans notre région. 
                     N'hésitez pas à me contacter quel que soit 
                     votre instrument et niveau. "]
      , p  [] [text "Contact :"]
      , p  [] [text "Tel: 06 13 39 33 01"]
      , mail "mariefranc@orange.fr"

      ]
 
