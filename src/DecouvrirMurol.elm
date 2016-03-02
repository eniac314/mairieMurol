module DecouvrirMurol where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initAtPhoto,view,update,Action)
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
  { wrapper : (Html -> Bool -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Murol.Menu
  , subMenu     : Murol.Submenu
  , mainContent : MainContent
  , showIntro   : Bool
  }  

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  , showIntro   = if String.isEmpty locationSearch
                  then True
                  else False
  }



-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Tourisme", "Découvrir Murol"]
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

port locationSearch : String

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }


initialWrapper : Html -> Bool -> Html
initialWrapper = 
  (\content showIntro ->
       div [ class "subContainerData noSubmenu", id "decouvrirMurol"]
           [ h2 [] [text "Découvrir Murol"]
           , p  [ classList [("intro",True),("displayIntro", showIntro)]]
                [ text "La commune de Murol, située au cœur du 
                       Parc des Volcans d’Auvergne, fait partie du canton 
                       du Sancy. Elle est composée de plusieurs villages 
                       et couvre une superficie de 15 km² avec 
                       une altitude qui varie de 785m à 1500m. "]
           , p  [ classList [("intro",True),("displayIntro", showIntro)]]
                [ text "Renommée depuis le début du XXème siècle, Murol 
                       est une station classée de tourisme aux nombreux 
                       attraits : beauté des paysages préservés, richesse historique, 
                       culturelle et patrimoniale, animations diversifiées et familiales tout 
                       au long de l’année… "]
           , h3 [classList [("intro",True),("displayIntro", showIntro)]]
                [text "Les villages et hameaux"]
           , content])





initialContent =
  { wrapper = initialWrapper
    
  , tiledMenu =
      initAtPhoto locationSearch
            [( "Le bourg de Murol"
            , "/images/tiles/decouvrirMurol/murolTile.jpg"
            , [ img [src "/images/2 Murol, le bourg.JPG", id "bourg1"] [] 
              , p  [] [text "Le bourg de Murol est implanté dans un 
                             écrin de verdure à 850 mètres d'altitude, dans 
                             la vallée de la Couze Chambon, sur le 
                             versant Est du massif du Sancy."]
              , p [] [ text "Enchâssé entre le volcan boisé du "
                     , a [href "/DécouvrirMurol.html?bloc=Le volcan du Tartaret"]
                         [text "Tartaret"]
                     , text " le promontoire du "
                     , a [href "/DécouvrirMurol.html?bloc=01"]
                         [text "château de Murol"]
                     , text " et le puy 
                           de Bessolles, le village vous ravira par ses 
                           sites remarquables et pittoresques. "
                     ]
              
              , p []
                     [ text "Au pied du château, vous découvrirez le parc 
                            arboré du Prélong où se trouvent le "
                     , a [ target "_blank", href "http://www.musee-murol.fr/fr"]
                         [ text "musée des Peintres de l’Ecole de Murols"]
                     , text " et le musée archéologique. Depuis le bourg, vous pourrez rejoindre 
                             la plage de Murol, au bord du "
                     , a [href "/DécouvrirMurol.html?bloc=Lac Chambon"]
                         [text "lac Chambon"]
                     , text " en empruntant "
                     , a [href "/DécouvrirMurol.html?bloc=La voie verte"]
                         [text "la voie verte"]
                     , text "."
                     ]
              , p [] [ text "Le bourg de Murol offre de nombreux "
                     , a [href "/Commerces.html"] [text "commerces et services"]
                     , text ". Le marché hebdomadaire a lieu chaque 
                            mercredi matin. " 
                     ]
              , p [class "toClear"] [ text "Murol est animé tout au long de l’année par de "
                     , a [href "/Animation.html"]
                         [text "grandes manifestations"]
                     , text " à destination d’un public 
                             familial. Chaque dimanche de la saison estivale vous 
                             pourrez participez à une visite insolite du bourg 
                             en suivant Monsieur Alphonse…"
                     ]
              , img [src "/images/prélong.JPG", id "bourg2"] []
              , img [src "/images/museePeintre.jpeg", id "bourg3"] [] 

              ]
            )
            ,
            ( "Le château"
            , "/images/tiles/decouvrirMurol/chateauTile.jpg"
            , [ img [src "/images/chateau1.jpg", id "chateau1"] []
              , p [] [ text "Edifié à l'emplacement probable d'un ancien camp romain, 
                             la construction de cette puissante forteresse médiévale s'étale 
                             du XIIème au XVIIIe siècle. "]
              , p [] [ text "Après être resté trois siècles dans les mains 
                             de la noble famille de Murol, le château 
                             deviendra, au XVème siècle, propriété des Estaing. De 
                             nombreux travaux seront alors entrepris pour moderniser les 
                             conditions de vie et adapter le système de 
                             défense du château aux exigences de l'artillerie. "]
              , p [] [text "Délaissé par ses derniers possesseurs, le château tombe 
                            en ruines au XIXème siècle. "]

              , p [] [text "Depuis près d’un siècle, en étroite collaboration avec 
                           les Monuments Historiques, le château a été activement 
                           rénové, ce qui a permis l’accueil du public. 
                           Son architecture médiévale reste conservée. "]
              , p [] [text "Il est aujourd´hui propriété de la commune et 
                            est géré par un délégataire. "]
              , p [] [text "C'est le château le plus visité d’Auvergne. Il 
                           attire plus de 100 000 visiteurs par an 
                           qui peuvent profiter de "
                     , a [target "_blank", href "www.chateaudemurol.fr"]
                         [text "visites simples ou animées"]  
                     ,text ", de saynètes et de démonstrations. Paysans, hommes d´armes, 
                           gentes dames et chevaliers vous font découvrir la 
                           vie d´une châtellenie au XIIIe siècle! "
                     ]
              , p [] [text "Depuis plusieurs années, des "
                     ,a [target "_blank", href "https://sites.google.com/site/murolarcheoancien"]
                        [text "recherches archéologiques"] 
                     ,text " sont conduites 
                           au château et sur l’ensemble de la commune 
                           afin de retracer l’histoire de ce territoire dont 
                           de nombreux vestiges témoignent d’une occupation gauloise (dolmen) 
                           et gallo-romaine (villa et fanum). Elles sont menées 
                           par Dominique Allios, maître de conférences en archéologie 
                           et histoire de l’Art, et son équipe d’étudiants. 
                           Chaque vendredi soir du mois de juillet, ils 
                           animent des conférences archéologiques riches en rebondissements et 
                           font ainsi partager aux murolais et aux visiteurs 
                           les découvertes et avancées réalisées dans la semaine. 
                           (voir "
                     , a [] [text "présentation de Dominique Allios"]
                     , text ")"
                     ]
              ]
            )
            ,
            ("Beaune le froid"
            ,"/images/tiles/decouvrirMurol/beauneTile.jpg"
            , [ img [src "/images/four à pain Beaune.jpg", id "chateau1"] []
              , p  [] [ text "Petit village de montagne, deuxième bourg de la 
                             commune situé sur un haut plateau, Beaune-le-Froid est 
                             un village agricole très actif et réputé pour 
                             ses "
                      , a [href "/Agriculture.html"]
                          [text "fromages de Saint-Nectaire fermier AOP"]
                      , text ", fabriqué depuis 
                             le XVIème siècle sur la commune. C'est un 
                             lieu de promenade et de découverte du savoir-faire 
                             local. Il a su conserver son moulin à 
                             eau et son lavoir. "
                      ]
              , p [] [text "En 2011, son four à pain a été 
                           entièrement reconstruit par des bénévoles de l’association des 
                           « chantiers de jeunesse ». En 2014, d’autres 
                           jeunes de cette association ont permis de remettre 
                           en état le « chemin des caves » 
                           où les agriculteurs affinent leurs Saint-Nectaire. "]
              , p [] [text "Chaque lundi de la saison estivale, vous pourrez 
                           découvrir le patrimoine et les savoir-faire de ce 
                           village grâce à Michel Tardif. "]
              , p [] [text "Début juillet, une grande foire du Saint-Nectaire vous 
                           permettra de rencontrer les producteurs de fromage et 
                           d’autres produits du terroir. Bonne dégustation! "]
              , p [] [text "L’hiver, si les conditions climatiques sont favorables, vous 
                           pourrez pratiquez le ski de fond ou la 
                           randonnée en raquettes sur les pistes du domaine 
                           nordique de la forêt de Beaune-le-Froid. "] 
              ]
            )
            ,
            ("Le volcan du Tartaret"
            ,"/images/tiles/decouvrirMurol/tartaretTile.jpg"
            , [ p  [] [text "Le volcan du Tartaret est l’un des plus 
                             récents d’Auvergne. Il est à l’origine de la 
                             formation du lac Chambon, avec l’effondrement de l’ancien 
                             volcan de la Dent du Marais. (voir "
                      ,a [href ""]
                         [text "historique de Pierre Lavina"]
                      
                      ]
              ]
            )
            ,
            ("Lac Chambon"
            ,"/images/tiles/decouvrirMurol/lacChambonTile.jpg"
            , [  p  [] [text "La partie Est du lac occupe la commune
                             de Murol pour un tiers de sa superficie.
                             Le reste du lac se trouvant sur la
                             commune de Chambon sur lac. Le Lac Chambon
                             est un lac de barrage volcanique puisqu´il s´est
                             formé à la suite de l´éruption du Tartaret
                             il y a environ 8000 ans et de
                             l'effondrement de la dent du Marais , bloquant
                             ainsi le cours de la Couze Chambon. La
                             couze charrie une telle quantité d´alluvions que le
                             lac se rétrécit au fil des siècles. S'étalant
                             aujourd'hui sur 60 hectares, peu profond (6 m
                             maximum) et parsemé d´îlots , il s'ouvre largement
                             à l'ouest sur les paysages somptueux du massif
                             du Sancy. Le lac est aménagé pour la
                             baignade, les activités nautiques et la pêche. "]
              ]
            )
            ,
            ("La voie verte"
            ,"/images/tiles/decouvrirMurol/cheminTile.jpg"
            , [  p  [] [text "Les visiteurs peuvent découvrir, sur le plan fourni
                             par l’Office de Tourisme, le tracé de la
                             « Voie Verte » , qui a nettement
                             amélioré la circulation des piétons et des cyclistes
                             depuis son achèvement en 2009. Il s’agit d’un
                             sentier fléché , accessible aux handicapés, réalisé en
                             collaboration avec le Conseil Général, qui relie le
                             bourg de Murol au lac Chambon, en faisant
                             une boucle autour du volcan du Tartaret. Il
                             permet de sécuriser le cheminement des piétons et
                             des cyclotouristes tout en respectant l’environnement car les
                             engins motorisés y sont proscrits. "]
              , p [] [ text "L’accès piéton au château de Murol est lui aussi sécurisé :"]
              , p [] [ text "Les visiteurs qui partent du bourg peuvent le
                            rejoindre en empruntant un cheminement piéton qui longe
                            le mur du parc du Prélong. Le parc
                            animalier situé sur les pentes du château est
                            ceint d’un sentier également piéton, bordé d’une barrière
                            de bois, ce qui permet aux plus jeunes
                            de le suivre sans danger. Le retour au
                            bourg de Murol peut se faire en traversant
                            le Parc du Prélong, ce qui offre aux
                            visiteurs la possibilité de découvrir l’Arborétum, la serre,
                            mais aussi le musée archéologique et le musée
                            des Peintres. "]
              , p [] [ text "La place de l’Abbé Boudal, où se trouve
                            l’église, est un lieu au cœur du bourg
                            de Murol, où la circulation automobile est réglementée,
                            ce qui permet aux piétons de profiter pleinement
                            de l’endroit et de la vue du château
                            que l’on y découvre. "]
              , p [] [ text "En dehors du bourg, les visiteurs peuvent se
                             promener en toute sécurité sur les chemins balisés
                             par la communauté de communes du Massif du
                             Sancy. Ils représentent à Murol un réseau de
                             plusieurs dizaines de kilomètres de sentiers de PR
                             (petites randonnées). Des cartes et des topoguides sont
                             disponibles au bureau de l’Office de Tourisme. Ils
                             permettent aux visiteurs de découvrir les plus beaux
                             panoramas de notre commune, comme ci-dessous, le lac
                             Chambon vu du sommet du volcan du Tartaret. "]
              ]
            )
            ,
            
            ("Chautignat"
            ,"/images/tiles/decouvrirMurol/chautignatTile.jpg"
            , [ p  [] [ text "Le hameau de Chautignat est situé à flanc
                             de coteaux. Il bénéficie d'un ensoleillement maximum et
                             de prairies aux pentes douces favorables à l'élevage
                             comme aux cultures. A proximité du hameau se
                             trouvent les grottes de Rajat et le moulin
                             à eau de Landrode qui ont été les
                             lieux de créations artistiques dans la cadre de
                             la manifestation annuelle « Horizons rencontres Art et
                             Nature ». "]
              ]
            )
            ,
            ("Groire"
            ,"images/tiles/decouvrirMurol/groireTile.jpg"
            , [ p  [] [ text "Ces hameaux ont une activité rurale marquée, ils
                     se situent là où le fond de la
                     vallée s'élargit pour former de petites plaines propices
                     aux cultures. Traversés par la Couze Chambon et
                     les sentiers de randonnées, ils se prêtent à
                     la flânerie. A l’occasion de la fête de
                     Groire, le four à pain revit pour le
                     plaisir des petits et grands gourmands. "]
              ]
            )
            ,
            ("La Chassagne et les Ballats"
            ,"images/tiles/decouvrirMurol/chassagneTile.jpg"
            , [ p  [] [ text "Située sous le Château de Murol, La Chassagne
                              est un hameau de fermes et maisons particulières.
                              Ce lieu existait déjà sous Guillaume de Murol,
                              seigneur du Château au début du XVème siècle.
                              La légende raconte que Pierre Morand, \"concierge\" du
                              château s'est installé ici et a fondé \"la
                              Chassagne\". L'origine du nom vient des arbres présents
                              à cette époque, les chênes. Aujourd'hui, quelques-uns subsistent
                              sur les pentes du château, entrelacés avec les
                              pins et autres arbustes. "]
              ]
            )
           ]
  }
 