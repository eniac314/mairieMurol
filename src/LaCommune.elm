module LaCommune where

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

type alias Category =
  { title   : String
  , entries : List Entry
  }

type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address
                       ["Mairie", "La commune"]
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
  div [ class "subContainerData noSubmenu", id "laCommune"]
      [ h2 [] [text "La commune"]
      , p [] [text "La population de Murol est de 555 habitants 
                   (546 + 9 comptés à part). On compte 
                   266 résidences principales, avec une augmentation de + 
                   8% en 10 ans et 424 résidences secondaires, 
                   avec une augmentation de +9% sur la même 
                   période (INSEE 2009). Le commerce et les services 
                   représentent le principal secteur d’activité de notre commune 
                   avec 67% des établissements, mais l’agriculture reste présente 
                   avec 12% des établissements. "]
      , p [] [text "Le territoire du Parc Naturel Régional des Volcans 
                   d’Auvergne est la première destination touristique de la 
                   région. Il propose les sites emblématiques les plus 
                   fréquentés de la région Auvergne. Or, Murol, au 
                   cœur du Parc, se trouve cerné par les 
                   volcans de la Chaîne des Puys et les 
                   sommets du Sancy, surplombé par le château de 
                   Murol (deuxième site sur Sancy-Volcan) qui attire 100 
                   000 visiteurs payants par an. Le nombre de 
                   personnes passant au pied du château ne peut 
                   être quantifié avec exactitude, mais il est estimé 
                   à 300 000. "]
      , p [] [text "La fréquentation touristique est très importante : le 
                   taux de fonction touristique atteint dans notre vallée 
                   6.82, chiffre le plus élevé dans le massif 
                   du Sancy, qui est a comparé avec le 
                   chiffre moyen de 1.3 au niveau national et 
                   5.3, chiffre moyen des zones de montagne. La 
                   population de Murol est multipliée par plus de 
                   3 en hiver et plus de 5 en 
                   été grâce aux atouts dont notre destination touristique 
                   dispose. "]
      , p [] [text "Station Verte depuis 1964, notre commune convient parfaitement 
                   à des vacances orientées « Nature». C’est pourquoi, 
                   nous comptabilisons de nombreuses familles, notamment en été, 
                   qui profitent des activités de pleine nature, au 
                   lac ou sur nos sentiers. Dans une étude 
                   réalisée en décembre 2007, portant sur la composition 
                   de la clientèle en séjour à Murol, on 
                   compte 67.8% des visiteurs qui viennent en famille, 
                   22.3% en couple, 6.8% entre amis. Sans oublier 
                   qu’il y a un nombre non négligeable d’étrangers 
                   qui séjournent à Murol, nous ayant incité à 
                   nous rendre davantage accessible d’un point de vue 
                   linguistique avec, par exemple, la traduction de nos 
                   ouvrages au musée et l’emploi de personnel bilingue. "]
      , p [] [text "Par ailleurs, notre commune, qui se situe à 
                   deux pas des deux principales stations de ski 
                   alpin du Massif du Sancy, bénéficie de la 
                   présence d’un foyer de ski nordique (avec une 
                   zone de raquette) au village de Beaune-le-Froid, à 
                   1000m d’altitude. Les pistes s’étendent dans la Forêt 
                   de Beaune-leFroid (gérée par l’Office National des Forêts). 
                   Ce site engendre une certaine complémentarité dans l’offre 
                   et nous permet de compter également sur le 
                   tourisme hivernal dès le mois de décembre."]
      , p [] [text "En intersaison, nous accueillons davantage les vacanciers sans 
                   enfants, les seniors et un nombre croissant de 
                   camping-caristes, ce qui permet un allongement notable de 
                   la saison touristique."]
      
      , a  [ href "/Phototheque.html"] [ text "La phototheque"]
      , br [] []
      , a  [ href "/VillageFleuri.html"] [ text "Murol village fleuri"] 
      ]
      

-- Data
