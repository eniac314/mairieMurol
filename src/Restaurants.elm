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
      [ renderMainMenu' ["Tourisme", "Restaurants"]
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
       div [ class "subContainerData noSubmenu", id "restaurants"]
           [ restaurants
           , content])
  , tiledMenu =
      init [( "Restaurants"
            , "/images/tiles/restaurants/restaurants.jpg"
            , [ h5 [] [ text "A Beaune le Froid"]
              , makeTable "aBeauneLeFroid" restosBeaunes
              , h5 [] [ text "A Murol"]
              , makeTable "aMurol" restosMurol
              ]
            )
            ,
            ( "Bar brasserie"
            , "/images/tiles/restaurants/drinks.jpg"
            , [ makeTable "barBrasserie" barBrasserie
              , h5 [] [ text "Bar de Nuit"]
              , makeTable "barDeNuit" barDeNuit
              ]
            )
            ,
            ( "Famille plus"
            , "/images/tiles/hebergements/famillePlus.jpg"
            , [ makeTable "famillePlus"  famillePlus ]
            )
           ]
  }


-- Data
famillePlus = 
  let tables = restosMurol ++ restosBeaunes ++ barBrasserie ++ barDeNuit
  in List.filter (\e ->  (.label e) == FamillePlus) tables

restaurants =
  div [ id "restosTourisme"]
      [ h2 [] [text "Restaurants"]
      , p [] [ text "On ne peut évoquer l’Auvergne sans parler des
                     produits du terroir qui font sa réputation :
                     les cinq fromages AOC (Saint-Nectaire, Cantal, Salers, Fourme
                     d’Ambert et Bleu d’Auvergne). Les salaisons (oh !
                     le bon jambon d’Auvergne, les saucisses et les
                     saucissons), le tout arrosé, avec modération, de vins
                     non dénués de qualité : Saint-Pourçain, Châteaugay, Madargues,
                     Boudes ou Corent. "]
      , p [] [ text "Le tableau ne serait pas complet, si nous
                     ne citions quelques autres spécialités régionales comme la
                     truffade, l'aligot, la potée auvergnate, les tripoux ou
                     encore les lentilles du Puy que vous dégusterez
                     chaudes, agrémentées d'oignons et de quelques lardons ou,
                     en été, froides en salade... un délice... "]
      , p [] [ text "Après avoir débuté votre repas auvergnat par une
                     Gentiane ou une Salers, vous apprécierez sans aucun
                     doute de le terminer par une petite verveine. "]
      , p [] [ text "Le tout avec modération."]
    ]

restosBeaunes =
   [{ emptyTe |
      name  = "Les Sancy'Elles"
    , addr  = "63790 Beaune le Froid -MUROL"
    , descr = ["Crèperie, petite restauration"]
    , tel   = "04 7388 8118"
    }]

restosMurol =
  [{ emptyTe |
      name  = "Au Montagnard"
    , addr  = "Rue d'Estaing - 63790 MUROL"
    , descr = ["Plat à emporter au restaurant"]
    , tel   = "04 73 88 61 52"
    , mail  = "restaurant.aumontagnard@orange.fr"
    , site  = "http://restaurantaumontagnard.wifeo.com/"
    }
    ,
    { emptyTe |
      name  = "Chez Dame Galinette"
    , addr  = "Rue d'Estaing - 63790 MUROL"
    , tel   = "04 73 88 61 52"
    , site  = "murol@azureva-vacances.com"
    }
    ,
    { emptyTe |
      name  = "Le chalet de la plage"
    , addr  = "lac Chambon - 63790 MUROL"
    , tel   = "04 73 88 82 31"
    , mail  = "hotel@lac-chambon-plage.fr"
    }
    ,
    { emptyTe |
      name  = "Le Parc"
    , addr  = "Rue Georges Sand - 63790 MUROL"
    , tel   = "04 73 88 60 08"
    , fax   = "04 73 88 64 44"
    , mail  = "info@hotel-parc.com"
    }
    ,
    { emptyTe |
      name  = "Le Paris"
    , addr  = "Pace de la mairie - 63790 MUROL"
    , tel   = "04 73 88 60 09"
    , fax   = "04 73 88 69 82"
    , mail  = "info@hoteldeparis-murol.com"
    }
    ,
    { emptyTe |
      name  = "Le Piccotin \"Pizzéria\""
    , addr  = "Rue Georges Sand - 63790 MUROL"
    , tel   = "04 73 62 37 10"
    }
    ]



barBrasserie =
  [{ emptyTe |
      name  = "A Jour et Nuit"
    , addr  = "Rue Estaing - 63790 Murol"
    , tel   = "04 73 88 64 82"
    }
    ,
    { emptyTe |
      name  = "Auberge de la plage"
    , addr  = "La plage - 63790 Murol"
    , tel   = "04 73 88 67 90"
    }
    ,
    { emptyTe |
      name  = "L'Arbalète"
    , addr  = "Rue Georges Sand - 63790 Murol"
    , tel   = "04 73 88 85 79"
    , mail  = "restaurantlarbalete@gmail.com"
    }
    ,
    { emptyTe |
      name  = "Le café de la côte"
    , addr  = "Rue Chabrol - 63790 MUROL"
    , descr = ["café- restaurant- herboristerie- salle de concert
                - atelier de confection de bougies
                en cire d'abeille, etc."
                ,"Bière locale, hypocras (entendez par là :
                  vin aux épices médiéval), barbecue ."
                ,"L'ambiance ici est à la détente, et parfois à la
                 fête puisque des concerts y sont
                 organisés sporadiquement."]
    , tel   = "06 7941 0811"
    }
    ]
   

barDeNuit =
  [ { emptyTe |
      name  = "Cubana café"
    , addr  = "Place de la poste - 63790 Murol"
    , tel   = "04 73 88 85 79"
    , mail  = "larbalete@cegetel.net"
    }]