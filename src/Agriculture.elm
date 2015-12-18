module Agriculture where

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

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

-- Update

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
  div [ class "subContainerData", id "agriculture"]
      [ p [] [ text "Producteur fermier"]
      , link "Saint-Nectaire AOP" "http://www.fromages-aop-auvergne.com/AOP-Saint-Nectaire"
      , p [] [ text "C’est dans une ferme datant de 1970 que 
                     Josette TIXIER vous accueillera pour vous faire découvrir 
                     ses secrets de fabrication du saint-Nectaire. Avec son 
                     fils David à la traite et sa belle-fille 
                     Angélique à la fromagerie, c’est une affaire de 
                     famille ! Suite à votre visite de la 
                     fromagerie, vous aurez droit bien entendu à une 
                     petite dégustation ! "]
      , p  [] [ text "Situation Beaune-le-froid, rue de Clermont"]
      , h5 [] [ text "Visite guidée"]
      , p  [] [ text "Juillet et août : jeudi, vendredi, samedi à 9h15 (compter 1h)"]
      , h5 [] [ text "Vente au détail"]
      , p  [] [ text "Toute l’année, tous les jours (sauf le mardi) de 9h15 à 12h et de 15h à 20h"]
      , h5 [] [ text "Contactez-nous"]
      , p  [] [ text "Josette TIXIER, son fils David et son épouse Angélique LAIR"]
      , p  [] [ text "Tél./Fax. : 04.73.88.62.09"] 
      ] 