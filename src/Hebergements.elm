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
  { wrapper : (Html -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Utils.Menu
  , subMenu     : Utils.Submenu
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
      [ renderMainMenu ["Tourisme", "Hébergements"]
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
      init [( "Hôtels et résidences hôtelières"
            , "/images/tiles/hebergements/hotels.jpg"
            , [ p  [] [ text "Murol offre une grande diversité d'établissements, généralement indépendants. 
                             Beaucoup d'entre eux se sont engagés dans une 
                             démarche de qualité, symbolisées par différents labels. Certains 
                             sont hôtels restaurants et offrent une prestation en 
                             demi-pension et pension complète. "]
              , makeTable "Hôtels" (List.sortBy (.name) hotels)
              , contact
              ]
            )
            ,
            ( "Campings et aires de camping-cars"
            , "/images/tiles/hebergements/campings.jpg"
            , [ p  [] [ text "Ils offrent de bonnes conditions de confort et 
                             beaucoup d'entre eux s'engagent dans des démarches de 
                             qualité, symbolisées par différents labels. Certains d'entre eux 
                             proposent également des locations de mobil-homes, chalets ou 
                             bungalows."]
              , makeTable "Campings" campings
              , h4 [] [text "Aires de camping-cars"]
              , makeTable "Aires" (List.sortBy (.name) aires)
              , contact
              ]
            )
            ,
            ( "Chambres d'Hôtes"
            , "/images/tiles/hebergements/chambresHotes.jpg"
            , [ p  [] [ text "Elles répondent aux exigences actuelles de la clientèle, 
                             en proposant des prestations de très bon confort. 
                             Séjourner en chambre d'hôtes, c'est partager le quotidien 
                             de personnes passionnées par leur région et attentives 
                             à la qualité de l'accueil."]
              , makeTable "Chambres d'Hôtes" (List.sortBy (.name) chambresHotes)
              , contact
              ]
            )
            ,
            ( "Meublés et gîtes"
            , "/images/tiles/hebergements/meuble.jpg"
            , [ p  [] [ text "Très répandus dans le Massif du Sancy, ils 
                             répondront à toutes les attentes et à tous 
                             les budgets. Les meublés que nous vous proposons 
                             sont tous classés par la préfecture. Le classement, 
                             en étoiles, indique le degré de confort de 
                             la location. Certains sont même labellisés. "]
              , makeTable "Meublés" (List.sortBy (.name) meubles)
              , contact
              ]
            )
            ,
            ( "Villages Vacances"
            , "/images/tiles/hebergements/villageVac.jpg"
            , [ makeTable "Village Vacances"  azureva, contact ]
            )
            ,
            ( "Famille plus"
            , "/images/tiles/hebergements/famillePlus.jpg"
            , [ h5 [] [text "Hôtels et résidences hôtelières: "]
              , makeTable "" (List.filter (\e ->  (.label e) == FamillePlus) hotels)
              , h5 [] [text "Campings et aires de camping-cars: "]
              , makeTable "" (List.filter (\e ->  (.label e) == FamillePlus) (campings++aires))
              , h5 [] [text "Chambres d'Hôtes: "]
              , makeTable "" (List.filter (\e ->  (.label e) == FamillePlus) chambresHotes)
              , h5 [] [text "Meublés et gîtes: "]
              , makeTable "" (List.filter (\e ->  (.label e) == FamillePlus) meubles)
              , h5 [] [text "Villages Vacances: "]
              , makeTable "" (List.filter (\e ->  (.label e) == FamillePlus) azureva)
              , contact
              ]
            --, [ makeTable "famillePlus"  famillePlus ]
            )
           ]
  }


-- Data

contact = 
   p []
     [ text "Liste non exhaustive, contactez "
     , a [href ("mailto:"++"contactsite.murol@orange.fr")]
         [text "le webmaster"]
     , text " pour toute erreur ou oubli!"
     ]

famillePlus = 
  let tables = azureva ++ hotels ++ campings ++ meubles ++ chambresHotes
  in List.filter (\e ->  (.label e) == FamillePlus) tables

azureva = [{ emptyTe |
             name  = "Azureva"
           , label = FamillePlus
           , stars = Just 2
           , refOt = Just ("922722","https://www.sancy.com/hebergement-collectif/azureva-murol/") 
           , addr  = "route de Jassat 63790 MUROL"
           , descr = ["1 à 6 personnes, 250 lits"
                     , "Contact: azurèva MUROL - Villages & Résidences de Vacances"]
           , tel   = "04 73 88 58 58"
           , fax   = "04 73 88 58 00"
           , site  = "http://www.azureva-vacances.com/"
          }]

hotels = [{ emptyTe |
            stars = Just 2
          , name  = "Résidence des Dômes"
          , addr  = "rue de Groire, 63790 Murol"
          , refOt = Just ("922010","https://www.sancy.com/hebergement-collectif/residence-des-domes//")
          , tel   = "04 73 88 60 13"
          , fax   = "04 73 88 80 05"
          , mail  = "domes4@wanadoo.fr"
          , site  = "http://www.lesdomes.com"
          , descr = ["Résidence de tourisme"] 
         }
         ,
         { emptyTe |
            stars = Nothing
          , refOt = Just ("918257","https://www.sancy.com/hotel/hotel-du-parc/")
          , name  = "Hotel du Parc"
          , addr  = "rue George Sand 63790 MUROL"
          , tel   = "04 73 88 60 08 / 07 70 30 29 10"
          , fax   = "04 73 88 64 44"
          , descr = ["Hôtel restaurant"] 
         }
         ,
         { emptyTe |
            stars = Just 2
          , name  = "Hotel les Volcans"
          , addr  = "rue George Sand 63790 MUROL"
          , tel   = "04 73 88 80 19" 
          , descr = ["Hôtel"] 
         }
         ,
         { emptyTe |
            stars = Just 2
          , refOt = Just ("918292","https://www.sancy.com/hotel/hotel-des-pins/")
          , name  = "Hotel des Pins"
          , addr  = "rue du Levat 63790 MUROL"
          , tel   = "04 73 88 60 50"
          , fax   = "04 73 88 60 29"
          , descr = ["Hôtel restaurant"] 
         }
         ,
         { emptyTe |
            stars = Nothing
          , name  = "Hôtel du Domaine du Lac Chambon"
          , refOt = Just ("918276","https://www.sancy.com/hotel/hotel-domaine-du-lac-chambon/")
          , addr  = "Allée de la Plage 63790 MUROL"
          , tel   = "04 44 05 21 58"
          , descr = ["Hôtel restaurant"] 
         }
         --]
         ,
         { emptyTe |
            stars = Just 3
          , name  = "Hotel de Paris"
          , refOt = Just ("917440","https://www.sancy.com/hotel/hotel-de-paris/")
          , addr  = "Rue de la Vieille Tour 63790 Murol"
          , tel   = "04 73 88 19 09"
          , descr = ["Hôtel"]
          , mail  = "hoteldeparis.murol@orange.fr"
          , site  = "http://hoteldeparis-murol.com/"  
         }]

campings = 
  [{ emptyTe |
     stars = Just 3
   , label = FamillePlus
   , refOt = Just ("924637","https://www.sancy.com/camping/domaine-du-marais/")
   , name  = "Domaine du marais"
   , descr = ["chalets mobile homes piscine"]
   , addr  = "Le Marais - 63790 MUROL"
   , tel   = "04 73 88 85 85"
   , fax   = "04 73 88 64 63"
   , site  = "http://www.domaine-du-marais.com"
   }
   ,
   { emptyTe |
     stars = Just 3
   , label = FamillePlus
   , refOt = Just ("924640","https://www.sancy.com/camping/camping-le-repos-du-baladin/")
   , name  = "Le Repos du Baladin"
   , addr  = "Groire - 63790 Murol"
   , tel   = "04 73 88 61 93"
   , fax   = "04 73 88 66 41"
   , mail  = "reposbaladin@free.fr"
   , site  = "http://www.camping-auvergne-france.com"
   , descr = ["mobile homes piscine"]
   }
   ,
   { emptyTe |
     stars = Just 3
   , label = FamillePlus
   , refOt = Just ("924631","https://www.sancy.com/camping/le-domaine-du-lac-chambon/")
   , name  = "Domaine du Lac"
   , addr  = "Allée de la Plage, 63790 MUROL"
   , tel   = "04 44 05 21 58"
   , descr = ["mobile homes chalet"]
   , site  = "http://www.domaine-lac-chambon.fr" 
   }
   ,
   { emptyTe |
     stars = Just 3
   , label = FamillePlus
   , refOt = Just ("924636","https://www.sancy.com/camping/les-fougeres/")
   , name  = "Les Fougères"
   , addr  = "Pont du Marais - 63790 MUROL"
   , tel   = "04 73 88 67 08"
   , fax   = "04 73 88 64 63"
   , mail  = "contact@les-fougeres.com"
   , site  = "http://www.les-fougeres.com"
   , descr = ["chalets mobile homes piscine"]
   }
   ,
   --{ emptyTe |
   --  stars = Just 4
   --, name  = "Camping de la Rybeyre"
   --, addr  = "Jassat - 63790 MUROL"
   --, tel   = "04 73 88 64 29"
   --, fax   = "04 73 88 68 41"
   --, mail  = "laribeyre@free.fr"
   --}
   --,
   { emptyTe |
     stars = Just 4
   , label = FamillePlus
   , refOt = Just ("924641", "https://www.sancy.com/camping/camping-leurope/")
   , name  = "Camping de l'Europe"
   , addr  = "Route de Jassat - 63790 - Murol"
   , tel   = "04 73 88 60 46"
   , fax   = "04 73 88 69 57"
   , mail  = "contact@camping-europe-murol.com"
   , site  = "http://www.camping-europe-murol.com"
   , descr = ["mobile homes piscine"]
   }
   ]

aires = 
  [ { emptyTe |
      descr = ["aire de service et d'accueil"]
    , refOt = Just ("924666","https://www.sancy.com/camping/aire-de-service-et-daccueil-du-domaine-du-lac/")
    , name  = "Domaine du Lac Chambon"
    , addr  = "Allée de la Plage 63790 MUROL"
    , tel   = "04 44 05 21 58"
    , site  = "http://www.domaine-lac-chambon.fr"
   }
   ,
   { emptyTe |
      descr = ["aire de service et d'accueil"]
    , refOt = Just ("924669","https://www.sancy.com/camping/aire-de-service-et-daccueil-leurope/")
    , stars = Just 4
    , name  = "L'Europe"
    , addr  = "route de Jassat 63790 MUROL"
    , mail  = "contact@camping-europe-murol.com"
    , site  = "http://www.camping-europe-murol.com"
   }
  ]

chambresHotes = 
  [{ emptyTe |
     stars = Just 2
   , name  = "La Clé des champs"
   , refOt = Just ("921341","https://www.sancy.com/chambre-hotes/la-cle-des-champs/")
   , addr  = "Route de Groire - 63790 MUROL"
   , tel   = "04 73 88 66 29 / 06 21 49 42 94"
   }
   ,
   { emptyTe |
     stars = Nothing
   , name  = "Marie Roche"
   , refOt = Just ("921361","https://www.sancy.com/chambre-hotes/marie-roche/")
   , addr  = "Groire - 63790 MUROL"
   , tel   = "04 73 88 64 99 / 06 11 57 97 72"
   }
   ,
   --{ emptyTe |
   --  stars = Nothing
   --, name  = "Auvergne France homes"
   --, addr  = "303 rue Pardaniche - 63790 MUROL"
   --, tel   = "04 73 88 81 65"
   --}
   --,
   { emptyTe |
     stars = Nothing
   , name  = "Le Dolmen"
   , addr  = "La Chassagne 63790 MUROL"
   , tel   = "04 73 88 81 67"
   }
   ]

meubles = 
  [{ emptyTe |
     epis  = "2 épis"
   , stars = Just 3
   , name  = "La Cacode"
   , refOt = Just ("2800891","https://www.sancy.com/meubles-gites/la-cacode/")
   , descr = ["Maison 4 personnes","Contact: Mme CLEMENT Marie-Paule"]
   , addr  = "La Chassagne - 63790 Murol"
   , tel   = "04 73 65 36 00"
   , mail  = "lachassagne@hotmail.fr"
   , site  = "http://lachassagne.e-monsite.com/"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "La Quiétude"
   , refOt = Just ("4609702","https://www.sancy.com/meubles-gites/la-quietude/")
   , label = FamillePlus
   , descr = ["Maison 8 personnes","Contact: Mme PLANEIX Suzanne"]
   , addr  = "Rue de Groire 63790 MUROL"
   , tel   = "04 73 78 65 08 - 06 95 29 30 48"
   , mail  = "suzanne.planeix@orange.fr"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Gite Bergogne"
   , refOt = Just ("2885","http://www.sancy.com/hebergements/detail/2885/murol/gite-bergogne") 
   , descr = ["Maison mitoyenne 8 personnes", "Contact: centrale de réservation du Sancy"]
   , addr  = "Beaune le froid - 63790 MUROL"
   , tel   = "04 73 65 36 00"
   }
   ,
   { emptyTe |
     stars = Just 3
   , name  = "Villa Mathieu"
   , refOt = Nothing
   , descr = ["6 à 8 personnes","Contact: Mme MATHIEU Anne-Marie"]
   , addr  = "Place de l'hôtel de ville - 63790 MUROL"
   , tel   = "04 73 93 69 19 / 07 50 35 54 63"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Entre château et volcans / Jonquilles"
   , refOt = Just ("3699","http://www.sancy.com/hebergements/detail/3699/murol/entre-chateau-et-volcans-jonquilles")
   , label = FamillePlus
   , descr = ["Appartement 2 personnes", "Contact: Mme DEBOUT Véronique"]
   , addr  = "route de Besse - 63790 MUROL"
   , tel   = "04 73 88 67 56 / 06 28 06 81 77"
   , site  = "http://www.entre-chateau-et-volcans.fr"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "le Chapuzadou"
   , refOt = Just ("4622601","https://www.sancy.com/meubles-gites/le-chapuzadou/")
   , descr = ["Maison 3 personnes", "Contact: Mme CLEMENT Marie-Paule"]
   , addr  = "La Chassagne - 63790 Murol"
   , tel   = "04 73 65 36 00"
   , mail  = "lachassagne@hotmail.fr"
   --, site  = "http://lachassagne.e-monsite.com/"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Les Cigales"
   , refOt = Just ("4622806","https://www.sancy.com/meubles-gites/les-cigales/")
   , descr = ["Appartement 5 personnes","Contact: Mme JULIEN Simone"]
   , addr  = "Rue de Groire - 63790 MUROL"
   , tel   = "04 73 88 80 87"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "La Clé des champs"
   , refOt = Just ("4622644","https://www.sancy.com/meubles-gites/la-cle-des-champs/")
   , descr = ["4 personnes","Contact: M. & Mme DELPEUX Annie et François"]
   , addr  = "Route de Groire - 63790 MUROL"
   , tel   = "04 73 88 66 29 - / 06 21 49 42 94 - 06 77 11 62 06"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Les Elfes n°6"
   , label = FamillePlus
   , refOt = Just ("3125","http://www.sancy.com/hebergements/detail/3125/murol/les-elfes-n6")
   , descr = ["Appartement 4 personnes, Contact: Mme JUAN Alice"]
   , addr  = "Route de Jassat - 63790 MUROL"
   , tel   = "04 73 88 61 16 - Portable : 06 88 76 81 70 - joignable : de 9h à 20h"
   , mail  = "les.elfes@orange.fr"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Les Genêts"
   , refOt = Just ("4622949","https://www.sancy.com/meubles-gites/les-genets/")
   , descr = ["Appartement 4 personnes","Contact: M. NOTHEISEN Marc"]
   , addr  = "Rue d'Estaing - 63790 MUROL"
   , tel   = "03 86 73 72 25 / 06 83 59 00 67"
   , mail  = "monique-notheisen@orange.fr"
   , site  = "http://lesgenets.murol.monsite-orange.fr"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Résidence Clair logis n°1"
   , refOt = Just ("1468","http://www.sancy.com/hebergements/detail/1468/murol/residence-clair-logis-n1")
   , descr = ["Appartement 3 personnes","Contact: M. LAPORTE Rémy"]
   , addr  = "Rue George Sand - 63790 MUROL"
   , tel   = "04 73 88 65 43"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Résidence Clair logis n°2"
   , refOt = Just ("1469","http://www.sancy.com/hebergements/detail/1469/murol/residence-clair-logis-n2")
   , descr = ["Appartement 4 personnes","Contact: M. LAPORTE Rémy"]
   , addr  = "Rue George Sand - 63790 MUROL"
   , tel   = "04 73 88 65 43"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Villa Roux"
   , refOt = Just ("2800984","https://www.sancy.com/meubles-gites/villa-roux/")
   , descr = ["Maison mitoyenne 6 personnes",
              "Contact: M. ROUX André"]
   , addr  = "Beaune-le-Froid - 63790 MUROL"
   , tel   = "04 73 87 51 47"
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Villa Roux"
   , refOt = Just ("2800985","https://www.sancy.com/meubles-gites/villa-roux-2/")
   , descr = ["Maison mitoyenne 4 personnes",
              "Contact: M. ROUX André"]
   , addr  = "Beaune-le-Froid - 63790 MUROL"
   , tel   = "04 73 87 51 47"
   }
   ,
   { emptyTe |
     stars = Just 1
   , name  = "Villa Roux"
   , refOt = Just ("2880170","https://www.sancy.com/meubles-gites/villa-roux-3/")
   , descr = ["Maison mitoyenne 5 personnes",
              "Contact: M. ROUX André"]
   , addr  = "Beaune-le-Froid - 63790 MUROL"
   , tel   = "04 73 87 51 47"
   }
   ,
   { emptyTe |
     stars = Just 1
   , name  = "Mon Gai Repos"
   , refOt = Just ("2880152","https://www.sancy.com/meubles-gites/mon-gai-repos/")
   , descr = ["Appartement 2 personnes",
              "Contact: Mme POMMIER-DESSERRE Madeleine"]
   , addr  = "Groire - 63790 MUROL"
   , tel   = "04 73 88 60 65 / 06 63 71 70 03"
   }
   ,
   { emptyTe |
     name  = "La Christaline"
   , refOt = Just ("1453","http://www.sancy.com/hebergements/detail/1453/murol/la-christaline")
   , descr = ["Studio 2 personnes"
             , "Contact: M. HENRY Christian"]
   , tel   = "04 73 88 66 19/ 05 63 75 45 24/ 06 87 97 35 40"
   , addr  = "Groire – 63790 MUROL"
   , mail  = "henrymurol@orange.fr"
   , site  = "http://murolsejourplus.wifeo.com"
   }
   ,
   { emptyTe |
     name  = "La Christaline"
   , refOt = Just ("6586","http://www.sancy.com/hebergements/detail/6586/murol/la-christaline")
   , descr = ["Appartement 5 personnes"
             , "Contact: M. HENRY Christian"]
   , tel   = "04 73 88 66 19/ 05 63 75 45 24/ 06 87 97 35 40"
   , addr  = "Groire – 63790 MUROL"
   , mail  = "henrymurol@orange.fr"
   , site  = "http://murolsejourplus.wifeo.com"
   }
   ,
   { emptyTe |
     name  = "Résidence de Michèle"
   , descr = ["6 appartements 2 à 4 personnes"
             , "Contact: Mme GONTELLE Fanny"]
   , tel   = "04 73 88 68 68 / 06 22 33 41 13"
   , addr  = "Rue du Tartaret - 63790 MUROL"
   , mail  = "residencedemichele@orange.fr"
   , site  = "http://residencedemichele.monsite-orange.fr"
   }
   ,
   { emptyTe |
     name  = "Résidence de Michèle"
   , stars = Just 3
   , descr = ["Appartement 2 à 4 personnes"
             , "Contact: Mme GONTELLE Fanny"]
   , tel   = "04 73 88 68 68 / 06 22 33 41 13"
   , addr  = "Rue du Tartaret - 63790 MUROL"
   , mail  = "residencedemichele@orange.fr"
   , site  = "http://residencedemichele.monsite-orange.fr"
   }
   ,
   { emptyTe |
     name  = "Gîte de groupe le Dolmen"
   , refOt = Just ("925767","https://www.sancy.com/hebergement-collectif/gite-de-groupe-le-dolmen/")
   , descr = ["Gîte de groupe 25 personnes"]
   , tel   = "04 73 61 49 64 / 06 42 90 73 53"
   , addr  = "La Chassagne 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Gîte Roux 1"
   , stars = Just 3 
   , refOt = Just ("3473","http://www.sancy.com/hebergements/detail/3473/murol/gite-roux-1")  
   , descr = ["Maison mitoyenne 5 personnes"
             , "Contact: centrale de réservation du Sancy"]
   , tel   = "04 73 65 36 00"
   , addr  = "Beaune-le-Froid 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Gîte Roux 2"
   , stars = Just 2 
   , refOt = Just ("3476","http://www.sancy.com/hebergements/detail/3476/murol/gite-roux-2")  
   , descr = ["Maison mitoyenne 6 personnes"
             , "Contact: centrale de réservation du Sancy"]
   , tel   = "04 73 65 36 00"
   , addr  = "Beaune-le-Froid 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Gîte Roux 3"
   , stars = Just 3 
   , refOt = Just ("3475","http://www.sancy.com/hebergements/detail/3475/murol/gite-roux-3")  
   , descr = ["Maison mitoyenne 5 personnes"
             , "Contact: centrale de réservation du Sancy"]
   , tel   = "04 73 65 36 00"
   , addr  = "Beaune-le-Froid 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Gîte Scopa"
   , refOt = Just ("7611","http://www.sancy.com/hebergements/detail/7611/murol/gite-scopa")  
   , stars = Just 3
   , descr = ["Maison 4 personnes"
             , "Contact: ARVERNHA RESORTS"]
   , tel   = "04 73 88 66 46"
   , addr  = "Rue Auguste Chauderon 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Gîte Servier"
   , stars = Just 3
   , refOt = Just ("8194","http://www.sancy.com/hebergements/detail/8194/murol/gite-servier")  
   , descr = ["Maison 6 personnes"
             , "Contact: centrale de réservation du Sancy"]
   , tel   = "04 73 65 36 00"
   , addr  = "rue du Lavoir Beaune-le-Froid 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "la Vie de Château"
   , stars = Just 3
   , refOt = Just ("4609790","https://www.sancy.com/meubles-gites/la-vie-de-chateau/")  
   , descr = ["Maison mitoyenne 6 personnes"
             , "Contact: ARVERNHA RESORTS"]
   , tel   = "04 73 88 66 46"
   , addr  = "rue de Chabrol 63790 MUROL"
   , site  = "https://www.facebook.com/media/set/?set=a.1629845623934236.1073741840.1629845083934290&type=1&l=8fb08fb351"
   }
   ,
   { emptyTe |
     name  = "la Villa blanche"
   , stars = Just 3
   , refOt = Just ("4609550","https://www.sancy.com/meubles-gites/la-villa-blanche/")  
   , descr = ["Maison 11 personnes"
             , "Contact: Mme DABERT-PANCRACIO Amélie"]
   , tel   = "04 73 88 61 06"
   , fax   = "04 73 88 63 53"
   , addr  = "rue de la Pardaniche, 63790 Murol"
   }
   ,
   { emptyTe |
     name  = "le Chalet des Noisettes"
   , stars = Just 3 
   , refOt = Just ("4609512","https://www.sancy.com/meubles-gites/chalet-des-noisettes/")  
   , descr = ["Chalet 4 personnes"
             , "Contact: ARVERNHA RESORTS"]
   , tel   = "04 73 88 66 46"
   , addr  = "Allée de la Plage 63790 MUROL"
   , site  = "https://www.facebook.com/media/set/?set=a.1630069510578514.1073741857.1629845083934290&type=1&l=84432e8458"
   }
   ,
   { emptyTe |
     name  = "les Fayards"
   , stars = Just 3  
   , descr = ["3 chalets 5 personnes"
             , "Contact: Mme AUBERTY Corinne"]
   , tel   = "04 73 88 64 28"
   , addr  = "Groire"
   , mail  = "auberty.francois@orange.fr"
   , site  = "http://les.fayards.free.fr"
   }
   ,
   { emptyTe |
     name  = "les Fushias"
   , stars = Just 2  
   , refOt = Just ("4622970","https://www.sancy.com/meubles-gites/les-fushias/")  
   , descr = ["Appartement 2 personnes"
             , "Contact: Mme PEUCH Jeanine "]
   , tel   = "04 73 88 68 28"
   , addr  = "rue de Groire 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Villa Bel-Hêtre"
   , stars = Just 4
   , refOt = Just ("2809608","https://www.sancy.com/meubles-gites/villa-bel-hetre/")  
   , descr = ["Maison 8 personnes"
             , "Contact: ARVERNHA RESORTS"]
   , tel   = "04 73 88 66 46"
   , addr  = "Chemin de Groire 63790 MUROL"
   , site  = "https://www.facebook.com/media/set/?set=a.1629845500600915.1073741838.1629845083934290&type=1&l=a1bb153598"
   }
   ,
   { emptyTe |
     name  = "Villa Marie Louise étage"
   , stars = Just 3
   , refOt = Just ("5302","http://www.sancy.com/hebergements/detail/5302/murol/villa-marie-louise-etage")  
   , descr = ["Appartement 6 personnes"
             , "Contact: Mme GUITTARD Crystel"]
   , tel   = "04 73 61 31 47 / 06 88 18 10 56"
   , addr  = "Groire 63790 MUROL"
   }
   ,
   { emptyTe |
     name  = "Les Vergers du Sancy"
   , refOt = Nothing
   , epis  = "3 épis"  
   , descr = ["Maison 2 personnes"
             , "Contact: Mme PICOT Monique"]
   , tel   = "04 73 88 65 79 / 06 84 29 28 25"
   , addr  = "La Chassagne 63790 MUROL"
   , mail  = "philippe.picot@orange.fr"
   , site  = "gite-vergers-sancy.com"
   }
   ,
   { emptyTe |
     name  = "Gîte de Jassaguet"
   , refOt = Just ("4609653","https://www.sancy.com/meubles-gites/gite-de-jassaguet/")  
   , descr = ["Maison 4 personnes"]
   , tel   = "04 73 88 66 46"
   , addr  = "Rue Jassaguet 63790 Murol"
   , mail  = ""
   , site  = "https://www.facebook.com/media/set/?set=a.1630071440578321.1073741858.1629845083934290&type=1&l=b3f317a2ed"
   }
   ,
   { emptyTe |
     name  = "Chalet Papon"
   , refOt = Just ("4746146","https://www.sancy.com/meubles-gites/chalet-papon/")  
   , descr = ["Maison 6 personnes"]
   , tel   = "04 73 35 69 82"
   , addr  = "Route de Clermont, Beaune le Froid 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Les Fougeoles"
   , refOt = Just ("4622448","https://www.sancy.com/meubles-gites/les-fougeolles/")  
   , descr = ["Maison 4 personnes"
             ]
   , tel   = "04 73 88 48 48"
   , addr  = "Pied du Puy de Tartaret, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Gîte chez Cadi"
   , refOt = Just ("2801001","https://www.sancy.com/meubles-gites/gite-chez-cadi/")  
   , stars = Just 3
   , descr = ["Maison 6 personnes"
             ]
   , tel   = "04 73 65 36 00"
   , addr  = "Rue du Lavoir - Beaune le Froid, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     stars = Just 2
   , name  = "Gîte des Dômes"
   , addr  = "rue de Groire, 63790 Murol"
   , refOt = Just ("4845395","https://www.sancy.com/hebergement-collectif/gite-des-domes/")
   , tel   = "04 73 88 60 13"
   , fax   = "04 73 88 80 05"
   , mail  = "domes4@wanadoo.fr"
   , site  = "http://www.lesdomes.com"
   , descr = ["Gîte de groupe"] 
       }
   ,
   { emptyTe |
     name  = "Appartement agréable"
   , refOt = Just ("4633164","https://www.sancy.com/meubles-gites/appartement-agreable/")  
   , descr = ["Meublé 4 personnes"
             ]
   , tel   = "06 58 63 06 27"
   , addr  = "Le Pré-long, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "La maison de Mémé"
   , stars = Just 3
   , refOt = Just ("4632842","https://www.sancy.com/meubles-gites/la-maison-de-meme/")  
   , descr = ["Maison 4 personnes"]
   , tel   = "04 73 61 31 47"
   , addr  = "Groire, 63790 Murol"
   , mail  = ""
   , site  = "http://www.gitesdegroire.com/"
   }
   ,
   { emptyTe |
     name  = "Le petit Lutess"
   , refOt = Just ("4631153","https://www.sancy.com/meubles-gites/le-petit-lutess/")  
   , descr = ["Appartement 4 personnes"]
   , tel   = "04 73 88 66 46"
   , addr  = "1 rue de Chabrol, 63790 Murol"
   , mail  = "contact@arvernha-resorts.com"
   , site  = "https://www.facebook.com/media/set/?set=a.1749357098649754.1073741872.1629845083934290&type=1&l=e85b755304"
   }
   ,
   { emptyTe |
     name  = "Les gîtes du paradis - n°3"
   , refOt = Just ("4631141","https://www.sancy.com/meubles-gites/les-gites-du-paradis-n3/")  
   , descr = ["Maison 4 personnes"
             ]
   , tel   = "06 63 25 56 47"
   , addr  = "Rue Charreton, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Les gîtes du paradis - n°2"
   , refOt = Just ("4631140","https://www.sancy.com/meubles-gites/les-gites-du-paradis-n2/")  
   , descr = ["Maison 4 personnes"
             ]
   , tel   = "06 63 25 56 47"
   , addr  = "Rue Charreton, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Les gîtes du paradis - n°1"
   , refOt = Just ("4631139","https://www.sancy.com/meubles-gites/les-gites-du-paradis-n1/")  
   , descr = ["Maison 6 personnes"
             ]
   , tel   = "06 63 25 56 47"
   , addr  = "Rue Charreton, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Gîte les Iris"
   , stars = Just 2
   , refOt = Just ("2800988","https://www.sancy.com/meubles-gites/gite-les-iris/")  
   , descr = ["Maison 6 personnes"
             ]
   , tel   = "04 73 65 36 00"
   , addr  = "Beaune-le-Froid, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Gîte les Mésanges"
   , stars = Just 3
   , refOt = Just ("2800987","https://www.sancy.com/meubles-gites/gite-les-mesanges-2/")  
   , descr = ["Maison 5 personnes"
             ]
   , tel   = "04 73 65 36 00"
   , addr  = "Beaune-le-Froid, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Gîte les Hirondelles"
   , refOt = Just ("2800986","https://www.sancy.com/meubles-gites/gite-les-hirondelles/")  
   , stars = Just 3
   , descr = ["Maison 5 personnes"
             ]
   , tel   = "04 73 65 36 00"
   , addr  = "Beaune-le-Froid, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   ,
   { emptyTe |
     name  = "Gîte le Beaune... heure"
   , stars = Just 3
   , refOt = Just ("2800862","https://www.sancy.com/meubles-gites/gite-le-beaune-heure/")  
   , descr = ["Maison 8 personnes"
             ]
   , tel   = "0473653600"
   , addr  = "Beaune-le-Froid, 63790 Murol"
   , mail  = ""
   , site  = ""
   }
   --,
   --{ emptyTe |
   --  name  = ""
   --, refOt = Just ("","")  
   --, descr = [""
   --          , "Contact: "]
   --, tel   = ""
   --, addr  = ""
   --, mail  = ""
   --, site  = ""
   --}
   --{ emptyTe |
   --  name  = "Les Homes de Vire Vent"
   --, descr = ["5 personnes"
   --          , "Melle Fanny Gontelle"]
   --, tel   = "04 73 69 76 64    Port : 06 07 30 95 43"
   --, addr  = "route de Jassat - 63790 MUROL"
   --, mail  = "legoueix.nicole@club-internet.fr"
   --, site  = "http://www.les-homes-de-virevent.com"
   --}
   ]