module Hebergements where

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
      [ renderMainMenu' ["Tourisme", "Hébergements"]
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
       div [ class "subContainerData noSubmenu", id "Hébergements"]
           [ h2 [] [text "Hébergements"]
           , content])
  , tiledMenu =
      init [( "Hotels"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ p  [] [ text "Murol offre une grande diversité d'établissements, généralement indépendants. 
                             Beaucoup d'entre eux se sont engagés dans desa 
                             démarches de qualité, symbolisées par différents labels. Certains 
                             sont hôtels restaurants et offrent une prestation en 
                             demi-pension et pension complète. "]
              , makeTable "Hotels" hotels
              ]
            )
            ,
            ( "Campings"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ p  [] [ text "Ils offrent de bonnes conditions de confort et 
                             beaucoup d'entre eux s'engagent dans des démarches de 
                             qualité, symbolisées par différents labels. Certains d'entre eux 
                             proposent également des locations de mobil-homes, chalets ou 
                             bungalows."]
              , makeTable "Campings" campings
              ]
            )
            ,
            ( "Chambres d'Hôtes"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ p  [] [ text "Elles répondent aux exigences actuelles de la clientèle, 
                             en proposant des prestations de très bon confort. 
                             Séjourner en chambre d'hôtes, c'est partager le quotidien 
                             de personnes passionnées par leur région et attentives 
                             à la qualité de l'accueil."]
              , makeTable "Chambres d'Hôtes" chambresHotes
              ]
            )
            ,
            ( "Meublés"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ p  [] [ text "Très répandus dans le Massif du Sancy, ils 
                             répondront à toutes les attentes et à tous 
                             les budgets. Les meublés que nous vous proposons 
                             sont tous classés par la préfecture. Le classement, 
                             en étoiles, indique le degré de confort de 
                             la location. Certains sont même labellisés. "]
              , makeTable "Meublés" meubles
              ]
            )
            ,
            ( "Village Vacances"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ makeTable "Village Vacances"  azureva ]
            )
           ]
  }


-- Data

azureva = [{ emptyTe |
             name  = "Azureva"
           , addr  = "route de Jassat 63790 MUROL"
           , descr = ["Contact:","azurèva MUROL - Villages & Résidences de Vacances"]
           , tel   = "04 73 88 58 58"
           , fax   = "04 73 88 58 00"
           , mail  = "murol@azureva-vacances.com"
           , site  = "http://www.azureva-vacances.com/Individuel/Village/Murol"
          }]

hotels = [{ emptyTe |
            stars = Just 2
          , name  = "Hotel les Dômes (résidence)"
          , addr  = "rue de Groire, 63790 Murol"
          , tel   = "04 73 88 60 13"
          , fax   = "04 73 88 80 05"
          , mail  = "domes4@wanadoo.fr"
          , site  = "http://www.lesdomes.com" 
         }
         ,
         { emptyTe |
            stars = Just 2
          , name  = "Hotel du Parc"
          , addr  = "rue George Sand 63790 MUROL"
          , tel   = "04 73 88 60 08"
          , fax   = "04 73 88 64 44"
          , descr = ["Hôtel restaurant"] 
         }
         ,
         { emptyTe |
            stars = Just 2
          , name  = "Hotel les Volcans"
          , addr  = "rue Estaing 63790 MUROL"
          , tel   = "04 73 88 80 19" 
         }
         ,
         { emptyTe |
            stars = Just 2
          , name  = "Hotel des Pins"
          , addr  = "rue du Levat 63790 MUROL"
          , tel   = "04 73 88 60 50"
          , fax   = "04 73 88 60 29"
          , descr = ["Hôtel restaurant"] 
         }
         ,
         { emptyTe |
            stars = Just 2
          , name  = "Hotel le Grillon"
          , addr  = "le lac Chambon 63790 MUROL"
          , tel   = "04 73 88 60 66"
          , fax   = "04 73 88 65 55"
          , descr = ["Hôtel restaurant"] 
         }
         ,
         { emptyTe |
            stars = Just 3
          , name  = "Hotel de Paris"
          , addr  = "Place de l’Hôtel de Ville 63790 MUROL"
          , tel   = "04 73 88 60 09"
          , fax   = "04 73 88 69 62"
          , descr = ["Hôtel restaurant"]
          , mail  = "info@hoteldeparis-murol.com"
          , site  = "http://www.hoteldeparis-murol.com"  
         }]

campings = 
  [{ emptyTe |
     stars = Just 3
   , name  = "Domaine du marais"
   , addr  = "Le Marais - 63790 MUROL"
   , tel   = "04 73 88 67 08"
   , fax   = "04 73 88 64 63"
   , site  = "www.domaine-du-marais.com"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Le Repos du Baladin"
   , addr  = "Groire - 63790 Murol"
   , tel   = "04 73 88 61 93"
   , fax   = "04 73 88 66 41"
   , mail  = "reposbaladin@free.fr"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Camping de la Plage"
   , addr  = "Centre touristique du lac Chambon - 63790 Murol"
   , tel   = "04 73 88 60 04"
   , mail  = "lac.chambon@wanadoo.fr"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Camping des Fougères"
   , addr  = "Pont du Marais - 63790 MUROL"
   , tel   = "04 73 88 67 68"
   , fax   = "04 73 88 64 63"
   , mail  = "camping-les-fougères@wanadoo.fr"
   , site  = "http://www.les-fougeres.com"
   }
   ,
   { emptyTe |
     stars = Just 4
   , name  = "Camping de la Rybeyre"
   , addr  = "Jassat - 63790 MUROL"
   , tel   = "04 73 88 64 29"
   , fax   = "04 73 88 68 41"
   , mail  = "laribeyre@free.fr"
   }
   ,
   { emptyTe |
     stars = Just 4
   , name  = "Camping de l'Europe"
   , addr  = "Route de Jassat - 63790 - Murol"
   , tel   = "04 73 39 76 66"
   , fax   = "04 73 39 76 61 "
   , mail  = "europe.camping@wanadoo.fr"
   }
   ]

chambresHotes = 
  [{ emptyTe |
     stars = Nothing
   , name  = "La Clé des champs"
   , addr  = "Route de Groire - 63790 MUROL"
   , tel   = "04 73 88 66 29"
   }
   ,
   { emptyTe |
     stars = Nothing
   , name  = "Marie Roche"
   , addr  = "Groire - 63790 MUROL"
   , tel   = "04 73 88 65 99 - Portable : 06 11 57 97 72"
   }
   ,
   { emptyTe |
     stars = Nothing
   , name  = "Auvergne France homes"
   , addr  = "303 rue Pardaniche - 63790 MUROL"
   , tel   = "04 73 88 81 65"
   }
   ,
   { emptyTe |
     stars = Nothing
   , name  = "Le Dolmen"
   , addr  = "Gite Le Dolmen La Chassagne 63790 MUROL"
   , tel   = "04 73 88 81 67"
   }
   ]

meubles = 
  [{ emptyTe |
     stars = Just 3
   , name  = "La Cacode"
   , descr = ["3* - 4 personnes","Mme CLEMENT Marie-Paule"]
   , addr  = "La Chassagne - 63790 Murol"
   , tel   = "04 7388 6085 (HR)"
   , mail  = "lachassagne@hotmail.fr"
   , site  = "http://lachassagne.e-monsite.com/"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "La Quiétude"
   , refOt = "5473"
   , label = FamillePlus
   , descr = ["3* - 8 personnes","Mme PLANEIX Suzanne"]
   , addr  = "Rue de la vieille tour - 63790 MUROL"
   , tel   = "04 73 78 65 08 - 06 95 29 30 48"
   , mail  = "info@hoteldeparis-murol.com"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Villa Bergogne"
   , refOt = "2885"
   , descr = ["3* - 8 personnes"]
   , addr  = "Beaune le froid - 63790 MUROL"
   , tel   = "04 73 65 36 00"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Villa Mathieu"
   , refOt = "1470"
   , descr = ["3* - 6 personnes","Mme MATHIEU Anne-Marie"]
   , addr  = "Place de l'hôtel de ville - 63790 MUROL"
   , tel   = "04 73 93 69 19 - Portable : 07 50 35 54 63"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Entre château et volcans"
   , refOt = "3699"
   , label = FamillePlus
   , descr = ["2* - 2 et 3 personnes"]
   , addr  = "route de Besse - 63790 MUROL"
   , tel   = "04 73 88 67 56 - Portable : 06 28 06 81 77"
   , mail  = "veronique.debout@gmail.com"
   , site  = "www.entre-chateau-et-volcans.fr"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Chapuzadou"
   , descr = ["2* - 4 personnes", "Mme CLEMENT Marie-Paule"]
   , addr  = "La Chassagne - 63790 Murol"
   , tel   = "04 7388 6085 (HR)"
   , mail  = "lachassagne@hotmail.fr"
   , site  = "http://lachassagne.e-monsite.com/"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Les Cigales"
   , refOt = "1467"
   , descr = ["2* - 4 personnes","Mme MATHIEU Anne-Marie"]
   , addr  = "Rue de Groire - 63790 MUROL"
   , tel   = "04 73 88 80 87"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "La clé des champs"
   , refOt = "1446"
   , descr = ["2* - 4 personnes","M. & Mme DELPEUX Annie et François"]
   , addr  = "Route de Groire - 63790 MUROL"
   , tel   = "04 73 88 66 29 - Portable : 06 21 49 42 94 - 06 77 11 62 06"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Les Elfes"
   , refOt = "3125"
   , descr = ["2* - 4 personnes"]
   , addr  = "Route de Jassat - 63790 MUROL"
   , tel   = "04 73 88 61 16 - Portable : 06 88 76 81 70 - joignable : de 10h à 21h"
   , mail  = "alice.elfes@wanadoo.fr"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Les Genêts"
   , refOt = "5336"
   , descr = ["2* - 4 personnes","M. NOTHEISEN Marc"]
   , addr  = "Rue d'Estaing - 63790 MUROL"
   , tel   = "03 86 73 72 25 - Portable : 06 83 59 00 67"
   , mail  = "monique-notheisen@orange.fr"
   , site  = "http://lesgenets.murol.monsite-orange.fr"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Résidence Clair logis"
   , refOt = "1469"
   , descr = ["2* - 3 et 4 personnes","M. LAPORTE Rémy"]
   , addr  = "Rue George Sand - 63790 MUROL"
   , tel   = "04 73 88 65 43"
   }
   ,
   { emptyTe |
     stars = Just 1
   , name  = "Villa Roux"
   , refOt = "1478"
   , descr = ["1* - 5 personnes",
              "Type habitation : maison mitoyenne",
              "M. ROUX André"]
   , addr  = "Beaune-le-Froid - 63790 MUROL"
   , tel   = "04 73 87 51 47"
   }
   ,
   { emptyTe |
     stars = Just 1
   , name  = "Mon Gai Repos"
   , refOt = "1516"
   , descr = ["1* - 2 personnes ",
              "Type habitation : appartement",
              "Mme POMMIER-DESSERRE Madeleine"]
   , addr  = "Groire - 63790 MUROL"
   , tel   = "04 73 88 60 65 - Portable : 06 63 71 70 03"
   }
   ,
   { emptyTe |
     name  = "La Christaline"
   , refOt = "6586"
   , descr = ["2* - studios 2 personnes et appartement 4 à 6 personnes"
             , "M. HENRY Christian"]
   , tel   = "04 73 88 66 19 - 05 63 75 45 24 - Portable : 06 87 97 35 40"
   , addr  = "Groire – 63790 MUROL"
   , mail  = "henrymurol@orange.fr"
   , site  = "http://murolsejourplus.wifeo.com"
   }
   ,
   { emptyTe |
     name  = "Résidence de Michèle"
   , descr = ["2 à 4 personnes"
             , "Melle Fanny Gontelle"]
   , tel   = "04 73 88 68 68 / Port : 06 22 33 41 13"
   , addr  = "Rue du Tartaret - 63790 MUROL"
   , mail  = "residencedemichele@orange.fr"
   , site  = "http://residencedemichele.monsite-orange.fr"
   }
   ,
   { emptyTe |
     name  = "Les Homes de Vire Vent"
   , descr = ["5 personnes"
             , "Melle Fanny Gontelle"]
   , tel   = "04 73 69 76 64    Port : 06 07 30 95 43"
   , addr  = "route de Jassat - 63790 MUROL"
   , mail  = "legoueix.nicole@club-internet.fr"
   , site  = "http://www.les-homes-de-virevent.com"
   }
   ]