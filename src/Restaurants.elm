module Restaurants where

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
      [ renderMainMenu ["Tourisme", "Restaurants"]
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
       div [ class "subContainerData noSubmenu", id "restaurants"]
           [ restaurants showIntro
           , content])
  , tiledMenu =
      init [( "Bars, brasseries et restaurants"
            , "/images/tiles/restaurants/restaurants.jpg"
            , [ 
              --h5 [] [ text "A Beaune le Froid"]
              --, makeTable "aBeauneLeFroid" restosBeaunes
                --h5 [] [ text "A Murol"]
                makeTable "aMurol" restosMurol
              , contact
              ]
            )
            --,
            --( "Bar brasserie"
            --, "/images/tiles/restaurants/drinks.jpg"
            --, [ makeTable "barBrasserie" barBrasserie
            --  , h5 [] [ text "Bar de Nuit"]
            --  , makeTable "barDeNuit" barDeNuit
            --  ]
            --)
            ,
            ( "Famille plus"
            , "/images/tiles/hebergements/famillePlus.jpg"
            , [ makeTable "famillePlus"  famillePlus, contact ]
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
  let tables = restosMurol ++ restosBeaunes
  in List.filter (\e ->  (.label e) == FamillePlus) tables

restaurants showIntro=
  div [ id "restosTourisme"]
      [ h2 [classList [("intro",True),("displayIntro", showIntro)]]
           [text "Restaurants"]
      , p [classList [("intro",True),("displayIntro", showIntro)]]
          [ text "On ne peut évoquer l’Auvergne sans parler des
                 produits du terroir qui font sa réputation :
                 les cinq fromages AOC (Saint-Nectaire, Cantal, Salers, Fourme
                 d’Ambert et Bleu d’Auvergne). Les salaisons (oh !
                 le bon jambon d’Auvergne, les saucisses et les
                 saucissons), le tout arrosé, avec modération, de vins
                 non dénués de qualité : Saint-Pourçain, Châteaugay, Madargues,
                 Boudes ou Corent. "]
      , p [classList [("intro",True),("displayIntro", showIntro)]]
          [ text "Le tableau ne serait pas complet, si nous
                 ne citions quelques autres spécialités régionales comme la
                 truffade, l'aligot, la potée auvergnate, les tripoux ou
                 encore les lentilles du Puy que vous dégusterez
                 chaudes, agrémentées d'oignons et de quelques lardons ou,
                 en été, froides en salade... un délice... "]
      , p [classList [("intro",True),("displayIntro", showIntro)]]
          [ text "Après avoir débuté votre repas auvergnat par une
                 Gentiane ou une Salers, vous apprécierez sans aucun
                 doute de le terminer par une petite verveine. "]
      , p [classList [("intro",True),("displayIntro", showIntro)]]
          [ text "Le tout avec modération."]
    ]

restosBeaunes =
   [{ emptyTe |
      name  = "Les Sancy'Elles"
    , addr  = "63790 Beaune le Froid -MUROL"
    , refOt = Just ("7980","http://www.sancy.com/activites/detail/7980/murol/les-sancy-elles")
    , descr = ["Restaurant crêperie"]
    , tel   = "04 73 88 81 18 / 06 29 39 04 77"
    }]

restosMurol =
  [ { emptyTe |
      name  = "A jour et nuit"
    , addr  = "Rue d'Estaing - 63790 MUROL"
    , descr = ["Bar brasserie restaurant"]
    , tel   = "04 73 88 64 82"
    }
    ,
    { emptyTe |
      name  = "Au Montagnard"
    , addr  = "Rue d'Estaing - 63790 MUROL"
    , descr = ["Plat à emporter au restaurant"]
    , tel   = "04 73 88 61 52"
    --, mail  = "restaurant.aumontagnard@orange.fr"
    , site  = "http://restaurantaumontagnard.wifeo.com/"
    }
    --,
    --{ emptyTe |
    --  name  = "Chez Dame Galinette"
    --, addr  = "Rue d'Estaing - 63790 MUROL"
    --, tel   = "04 73 88 61 52"
    --, site  = "murol@azureva-vacances.com"
    --}
    --,
    --{ emptyTe |
    --  name  = "Le chalet de la plage"
    --, addr  = "lac Chambon - 63790 MUROL"
    --, tel   = "04 73 88 82 31"
    --, mail  = "hotel@lac-chambon-plage.fr"
    --}
    --,
    --{ emptyTe |
    --  name  = "Le Parc"
    --, addr  = "Rue Georges Sand - 63790 MUROL"
    --, tel   = "04 73 88 60 08"
    --, fax   = "04 73 88 64 44"
    --, mail  = "info@hotel-parc.com"
    --}
    --,
    --{ emptyTe |
    --  name  = "Le Paris"
    --, addr  = "Pace de la mairie - 63790 MUROL"
    --, tel   = "04 73 88 60 09"
    --, fax   = "04 73 88 69 82"
    --, mail  = "info@hoteldeparis-murol.com"
    --}
    ,
    { emptyTe |
      name  = "les Pins"
    , descr = ["Restaurant"]
    , addr  = "Rue du Levat 63790 MUROL"
    , tel   = "04 73 88 60 50"
    , site  = "http://www.hoteldespins-murol.com"
    }
    ,
    { emptyTe |
      name  = "T-Me"
    , refOt = Just ("4080","http://www.sancy.com/activites/detail/4080/murol/t-me")
    , descr = ["Bar/bistrot restaurant pizzeria brasserie pub/bar de nuit"]
    , addr  = "route de Besse 63790 MUROL"
    , tel   = "09 81 36 69 58 / 06 68 48 00 04"
    , mail  = "t-me@hotmail.fr"
    }
    ,
    { emptyTe |
      name  = "L'imprevu"
    , descr = ["Bureau de tabac bar"]
    , addr  = "Rue Pierre Céleirol 63790 MUROL"
    , tel   = "04 73 87 99 61"
    }
    ,
    { emptyTe |
      name  = "Snack pizzeria  les Fougères le Domaine du Marais"
    , refOt = Just ("7640","http://www.sancy.com/activites/detail/7640/murol/snack-pizzeria-les-fougeres-domaine-du-marais")
    , descr = ["restaurant pizzeria sandwicherie snack"]
    , addr  = "Le Marais, 63790 MUROL"
    , tel   = "04 73 88 67 08 "
    }
    ,
    { emptyTe |
      name  = "Crêperie Le George Sand"
    , refOt = Just ("4050","")
    , descr = ["Restaurant crêperie"]
    , addr  = "Rue George Sand 63790 MUROL"
    , tel   = "06 28 29 55 99"
    , site  = "http://www.sancy.com/activites/detail/4050/murol/creperie-le-george-sand"
    }
    ,
    { emptyTe |
      name  = "Auberge de la Plage"
    , descr = ["bar brasserie restaurant"]
    , addr  = "La Plage de Murol 63790 MUROL"
    , tel   = "04 73 88 67 90"
    }
    ,
    { emptyTe |
      name  = "le Domaine du Lac"
    , label = FamillePlus
    , refOt = Just ("4041","http://www.sancy.com/activites/detail/4041/murol/le-restaurant-du-domaine-du-lac")
    , descr = ["Bar/bistrot brasserie restaurant"]
    , addr  = "Plage de Murol 63790 MUROL"
    , tel   = "04 44 05 21 58"
    , mail  = "lac.chambon@wanadoo.fr"
    }
    ,
    --{ emptyTe |
    --  name  = "Cubana café"
    --, descr = ["Bar de nuit"]
    --, addr  = "Place de la poste 63790 MUROL"
    --, tel   = "04 73 88 85 79"
    --}
    --,
    { emptyTe |
      name  = "Le Picotin"
    , descr = ["Restaurant pizzeria"]  
    , refOt = Just ("4075","http://www.sancy.com/activites/detail/4075/murol/le-picotin")
    , label = FamillePlus
    , addr  = "Rue George Sand - 63790 MUROL"
    , tel   = "04 73 62 37 10 / 06 83 00 11 85"
    }
    ,
    { emptyTe |
      name  = "L'Arbalète"
    , refOt = Just ("4034","http://www.sancy.com/activites/detail/4034/murol/l-arbalete")
    , addr  = "Rue George Sand - 63790 Murol"
    , tel   = "04 73 88 85 79"
    , mail  = "restaurantlarbalete@gmail.com"
    }
    ]



--barBrasserie =
--  [{ emptyTe |
--      name  = "A Jour et Nuit"
--    , addr  = "Rue Estaing - 63790 Murol"
--    , tel   = "04 73 88 64 82"
--    }
--    ,
--    { emptyTe |
--      name  = "Auberge de la plage"
--    , addr  = "La plage - 63790 Murol"
--    , tel   = "04 73 88 67 90"
--    }
--    ,
--    { emptyTe |
--      name  = "L'Arbalète"
--    , refOt = Just ("4034","http://www.sancy.com/activites/detail/4034/murol/l-arbalete")
--    , addr  = "Rue Georges Sand - 63790 Murol"
--    , tel   = "04 73 88 85 79"
--    , mail  = "restaurantlarbalete@gmail.com"
--    }
--    ,
--    { emptyTe |
--      name  = "Le café de la côte"
--    , addr  = "Rue Chabrol - 63790 MUROL"
--    , descr = ["café- restaurant- herboristerie- salle de concert
--                - atelier de confection de bougies
--                en cire d'abeille, etc."
--                ,"Bière locale, hypocras (entendez par là :
--                  vin aux épices médiéval), barbecue ."
--                ,"L'ambiance ici est à la détente, et parfois à la
--                 fête puisque des concerts y sont
--                 organisés sporadiquement."]
--    , tel   = "06 7941 0811"
--    }
--    ]
   

--barDeNuit =
--  [ { emptyTe |
--      name  = "Cubana café"
--    , addr  = "Place de la poste - 63790 Murol"
--    , tel   = "04 73 88 85 79"
--    , mail  = "larbalete@cegetel.net"
--    }]