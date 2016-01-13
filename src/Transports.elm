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
            , [ navetteEte, navetteHs]
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

navetteEte = 
  div []
      [ h5 [] [text "CHAMBON/LAC – MUROL – ST NECTAIRE ↔ CLERMONT-FERRAND"]
      , h5 [] [text "Chaque samedi en juillet et aout"]
      , table []
              [ tr []
                   [ th [colspan 3] [text "Aller"],th [colspan 3] [text "Retour"]]
              , toRow ["","Matin","Après-midi","","Matin","Après-midi"] True
              , toRow ["Chambon village","8h40","15h20","Clermont-Ferrand (gare routière) ","7h15","13h00 "] False
              , toRow ["Chambon petite plage","8h50","15h25","Clermont-Ferrand (gare SNCF)","7h25 ","13h10 "] True
              , toRow ["Murol","8h55","15h30","Plauzat ","7h45 ","13h30 "] False
              , toRow ["Saint-Nectaire  (Cornadore)","9h00","15h45","Champeix","7h50 ","13h35 "] True
              , toRow ["Saint-Nectaire (Office de tourisme)","9h05","15h50","Montaigut le Blanc ","7h55 ","13h40 "] False
              , toRow ["Saillant","9h10","16h00","Le Rivalet ","7h50","13h45"] True
              , toRow ["Le Rivalet","9h15","16h15","Saillant ","8h05","13h55"] False
              , toRow ["Montaigut le Blanc","9h20","16h20","Saint-Nectaire (Office de tourisme)","8h10 ","14h00 "] True
              , toRow ["Champeix","9h25","16h25","Saint-Nectaire  (Cornadore) ","8h20 ","14h10 "] False
              , toRow ["Plauzat","9h30","16h30","Murol ","8h30 ","14h20 "] True
              , toRow ["Clermont-Ferrand (gare SNCF)","10h00","17h00","Chambon petite plage ","8h35 ","14h30 "] False
              , toRow ["Clermont-Ferrand (gare routière)","10h10","17h10","Chambon village ","8h40 ","14h35 "] True
              ]
      , p [] [text " Correspondance avec FAURE AUVERGNE (ligne Besse/Clermont –Ferrand) Tél. : 04 73 39 97 15"]
      ]

navetteHs =
  div []
      [ h5 [] [text "Chaque mardi toute l'année (sauf jours fériés)"]
      , table []
              [ tr []
                   [ th [colspan 2] [text "Aller"],th [colspan 2] [text "Retour"]]
              , toRow ["Chambon village","9h15 ","Clermont-Ferrand (gare routière) ","16h09 "] False
              , toRow ["Chambon petite plage","9h20 ","Clermont-Ferrand (gare SNCF)","16h30 "] True
              , toRow ["Murol","9h25","Plauzat ","17h04"] False
              , toRow ["Saint-Nectaire  (Cornadore)","9h35 ","Champeix","17h09 "] True
              , toRow ["Saint-Nectaire (Office de tourisme)","9h40 ","Montaigut le Blanc ","17h13 "] False
              , toRow ["Saillant","9h45 ","Le Rivalet ","17h15 "] True
              , toRow ["Le Rivalet","10h00 ","Saillant ","17h25 "] False
              , toRow ["Montaigut le Blanc","10h05 ","Saint-Nectaire (Office de tourisme)","17h30 "] True
              , toRow ["Champeix","10h10 ","Saint-Nectaire  (Cornadore) ","17h40 "] False
              , toRow ["Plauzat","10h15 ","Murol ","17h50 "] True
              , toRow ["Clermont-Ferrand (gare SNCF)","10h35 ","Chambon petite plage ","17h55"] False
              , toRow ["Clermont-Ferrand (gare routière)","10h45","Chambon village","18h00"] True
              ]
      , p [] [text " Correspondance avec FAURE AUVERGNE (ligne Besse/Clermont –Ferrand) Tél. : 04 73 39 97 15"]
      ]

toRow :  List String -> Bool -> Html
toRow xs b = 
  let alt = if b then "row" else "rowAlt"  
  in tr [class alt] (List.map (\s -> td [] [text s]) xs) 