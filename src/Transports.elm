module Transports where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initAt,view,update,Action)
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

port locationSearch : String

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
      initAt locationSearch
            [("Dessertes de la commune"
            , "/images/tiles/transports/les dessertes.jpg"
            , [ p [] [text "La situation géographique de notre commune est un 
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
            )
            ,
            ( "Navette"
            , "/images/tiles/transports/navette.jpg"
            , [ navetteEte, navetteHs]
            )
            ,
            ( "Covoiturage"
            , "/images/tiles/transports/logo-covoiturage.jpg"
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
           , 
            ( "Déneigement"
            , "/images/tiles/transports/déneigement.jpg"
            , deneigement
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

deneigement = [ p [] [text "En raison de la situation de moyenne montagne 
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
               , a [href "/Carte&Plan.html#infoRoute"] [text "Etat des routes"]
              ]

toRow :  List String -> Bool -> Html
toRow xs b = 
  let alt = if b then "row" else "rowAlt"  
  in tr [class alt] (List.map (\s -> td [] [text s]) xs) 

