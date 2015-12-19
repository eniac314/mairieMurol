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
      [ renderMainMenu address (.mainMenu model)
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
  div [ class "subContainerData", id "laCommune"]
      [ p [] [text "La population de Murol est de 555 habitants 
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
      , h4 [] [text "Le déneigement sur la commune "]
      , p [] [text "En raison de la situation de moyenne montagne 
                   de la commune où l’altitude varie de 785 
                   mètres à 1500 mètres, certains hivers nécessitent un 
                   service de déneigement performant. La période d’enneigement s’étale 
                   de novembre à fin mars."]
      , p [] [text "Le déneigement des routes départementales situées sur la 
                   commune hors agglomération est du ressort des services 
                   du Conseil Général du Puy de Dôme. Le 
                   service est effectivement assuré, comme l’atteste le plan 
                   de viabilité hivernale fourni par le Conseil Général 
                   du Puy de Dôme."]
      , p [] [text "En agglomération, c’est à la commune de Murol 
                   qu’échoit le déneigement. Les services techniques communaux disposent 
                   de 5 employés chargés en alternance d’effectuer le 
                   déneigement. Des astreintes sont organisées pour les weekends 
                   du 15 novembre à fin mars afin de 
                   répondre au mieux aux besoins. Les employés utilisent 
                   du matériel spécifique qui a été renouvelé en 
                   2011. "]
      , h4 [] [text "Les dessertes de la commune par les transports"]
      , p [] [text "La situation géographique de notre commune est un 
                   atout considérable étant donné que celle-ci bénéficie d’une 
                   position centrale au niveau régional, mais également au 
                   niveau national , ce qui nous permet de 
                   recevoir des visiteurs venant de part et d’autres 
                   de la France."]
      , p [] [text "Au cœur du massif du Sancy, Murol se 
                   trouve effectivement à seulement 30 minutes des autoroutes 
                   A71, A72, A75 et A89 . Nous sommes 
                   donc relativement bien desservis, étant à quatre heures 
                   de Paris par l’A71 (3h10 en train) et 
                   de Montpellier (A75), à deux heures de Lyon 
                   (A72) et seulement à quatre heures de Bordeaux 
                   avec la nouvelle autoroute A89, qui permet une 
                   ouverture sur le Sud-Ouest. "]
      , p [] [text "Au niveau de l’accès par le train, les 
                   gares du Mont Dore, d’Issoire et de Clermont-Ferrand 
                   se situent respectivement à 25 minutes, 35 minutes 
                   et 40 minutes environ en voiture de Murol."]
      , p [] [text "Pour venir à Murol par avion, l’aéroport international 
                   de Clermont-Ferrand Aulnat est le plus proche. Il 
                   se situe à 40 minutes de voiture de 
                   Murol par l’autoroute A75. Les vols réguliers pour 
                   la France se font vers Ajaccio, Bastia, Biarritz, 
                   Bordeaux, Lille, Lyon, Marseille, Metz/Nancy, Montpellier, Nantes, Nice, 
                   Paris/Orly et Paris/Charles de Gaulle, Strasbourg, Toulouse."]
      , p [] [text "Les vols réguliers pour l’Europe, directs ou avec 
                   une correspondance, sont à destination des pays suivants 
                   : Belgique, Grande-Bretagne, Italie, Pays-Bas, Suisse, Allemagne, Espagne, 
                   Portugal, Norvège, Danemark, Suède, Finlande, Russie, Pologne, Autriche, 
                   République Tchèque, Hongrie, Serbie, Bulgarie et Grèce. "]
      , p [] [text "Pour un accès par le car, un service 
                   de navette permet de rejoindre Murol depuis la 
                   gare ou l’aéroport de Clermont-Ferrand. Elle effectue le 
                   trajet Chambon sur Lac - Murol - Saint-Nectaire 
                   – Champeix – Clermont-Ferrand, en service régulier tous 
                   les mardis de l’année, mais également le samedi 
                   en juillet et en août . En saison 
                   estivale l’offre de transport collectif est donc plus 
                   importante."]
      , p [] [text "Un service de réservation est disponible sur le 
                   site internet de l’Office de Tourisme du Sancy 
                   ainsi que les horaires et trajet des navettes. 
                   Les mêmes informations sont disponibles au bureau de 
                   l’Office de Tourisme de Murol ainsi qu’à la 
                   mairie."]
      , p [] [text "Un service de taxis indépendants est offert sur 
                   le territoire de la commune de Murol. "]
      , p [] [text "Enfin, la municipalité de Murol favorise le covoiturage 
                   en mettant à la disposition de tous, une 
                   aire de covoiturage répertoriée dans le schéma départemental 
                   du Conseil Général du Puy de Dôme ."]
      , p [] [text "Ainsi, il existe de nombreuses alternatives à la 
                   voiture individuelle pour se rendre à Murol, sans 
                   oublier que le GR30 traverse la commune et 
                   que certains randonneurs viennent à pied pour une 
                   halte d’une ou plusieurs nuits dans notre station."]
      ]
      

-- Data
