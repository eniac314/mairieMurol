module Transports where

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
      [ renderMainMenu' ["Vie Locale", "Transports"]
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
       div [ class "subContainerData noSubmenu", id "Transports"]
           [ h2 [] [text "Transports"]
           , content])
  , tiledMenu =
      init [( "Navette"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ text "Contenu disponible prochainement"]
            )
            ,
            ( "Covoiturage"
            , "/images/tiles/hebergements/placeholder.jpg"
            , [ p  [] [ text "Le concept du covoiturage est vraiment très simple 
                              ! Au lieu que chacun utilise sa voiture 
                              pour effectuer des trajets quotidiens ou ponctuels, le 
                              covoiturage vous permet d'utiliser une voiture pour plusieurs 
                              personnes. Cela permet évidement de réduire les coûts 
                              de transport (prix de l'essence, usure de la 
                              voiture, ...), la pollution, les temps de transport. "]
             , h5 [] [ text "L'aspect économique"]
             , p [] [ text "En effet, le covoiturage vous permettra de diminuer 
                            largement vos frais liés à vos trajets en 
                            voiture (essence, usure de la voiture, ...). Dans 
                            le cas d'un covoiturage alterné (plusieurs conducteurs qui 
                            conduisent par alternance) vous pourrez diviser vos frais 
                            de trajet par autant de conducteur qui participe 
                            au covoiturage. Dans le cas d'un covoiturage avec 
                            participation (Les passagers participent financièrement aux trajets), là 
                            encore on observera une nette diminution des frais 
                            engendrés par l'utilisation de votre voiture. "]
               , h5 [] [ text "Un geste pour l'écologie"]
               , p [] [ text "Le covoiturage est une pratique qui permet de 
                              diminuer significativement le nombre de voiture circulant sur 
                              les routes. La première conséquence est la diminution 
                              de la pollution et de l'émission des gaz 
                              à effet de serre. Ceci permet également la 
                              diminution de consommation d'énergie non renouvelable comme le 
                              pétrole. "]
               , h5 [] [ text "Créer ou trouver un trajet, suivez les liens ci-dessous"]
               , p [] [ link "http://www.covoiturageauvergne.net" "http://www.covoiturageauvergne.net"]
               , p [] [ link "http://www.covoiturage.fr/" "http://www.covoiturage.fr/"]
               ]
            )
           ]
  }