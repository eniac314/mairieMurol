module DecouvrirMurol where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (init,view,update,Action)
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
      [ renderMainMenu' ["Tourisme", "Découvrir Murol"]
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
       div [ class "subContainerData noSubmenu", id "Découvrir Murol"]
           [ h2 [] [text "Découvrir Murol"]
           , p [] [ text "La commune appartient au canton de
                          Besse-et-Saint-Anastaise et est composée
                          de quatre villages, Murol, Beaune le froid,
                          Groire et Chautignat. Elle s'étend sur une
                          superficie de 15 km² à une altitude de 785m à 1500m."]
           , h3 [] [text "Les villages et hameaux"]
           , content])
  , tiledMenu =
      init [( "Murol"
            , "/images/murolTile.jpg"
            , [ p  [] [text "Le bourg de Murol est implanté dans un écrin de verdure à
                             850 mètres d'altitude, dans la vallée de la Couze Chambon,
                             sur le versant oriental du Massif de Sancy, entre le volcan
                             boisé du Tartaret, le promontoire du Château de Murol
                             (monument historique classé) et le puy de Bessolles
                             culminant à 1057m. d'altitude. Il est également
                             travérsé par le GR30. A deux pas du Lac Chambon
                             et de la Vallée de Chaudefour (Réserve naturelle)
                             le village vous ravira par ses sites remarquables
                             ou pittoresques, par son parc arboré où se trouve
                             le musée des peintres."]
              , p [] [ text "De nombreux vestiges
                             témoignent d'une occupation gauloise (dolmen)
                             et gallo-romaine (villa et fanum). Au moyen-âge
                             s'élève une puissante forteresse, sa construction
                             s'étale du XIIème au XVIIIème siècle. Après être resté
                             trois siècles durant dans les mains de la noble famille
                             de Murol, le château deviendra au XV ème
                             siècle par mariage, propriété des Estaing, lesquels y
                             feront de nombreux travaux pour moderniser les conditions
                             de vie et adapter aux exigences de l'artillerie le système
                             de défense. Délaissé par ses derniers possesseurs,
                             le château tombe en ruines au XIX ème siècle.
                             Il est aujourd'hui propriété de la commune.
                             Des animations relatant la vie au moyen-âge s'y
                             déroulent et attirent environ 120 000 visiteurs par an."]
              ]
            )
            ,
            ("La desserte des principaux lieux touristiques"
            ,"/images/cheminTile.jpg"
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
            ("Beaune le froid"
            ,"/images/beauneTile.jpg"
            , [ p  [] [ text "Petit village de montagne, deuxième bourg de la
                             commune situé sur un haut plateau, Beaune le
                             froid est un village agricole très actif et
                             réputé pour ses fromages de Saint Nectaire fermier,
                             fabriqué depuis le XVIème siècle sur la commune.
                             C'est un lieu de promenade et de découverte
                             du savoir-faire local. Il a su conserver son
                             moulin à eau et son lavoir. En 2011,
                             son four à pain a été entièrement reconstruit
                             par des bénévoles de l’association des « chantiers
                             de jeunesse ». L’ hiver, l’ouverture du domaine
                             skiable permet la pratique du ski nordique et
                             des raquettes. "]
              ]
            )
            ,
            ("Chautignat"
            ,"/images/chautignat.JPG"
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
            ("Les hameaux des Ballats et Groire"
            ,"/images/groireTile.jpg"
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
            ("La Chassagne"
            ,"/images/chassagneTile.jpg"
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
            ,
            ("Le volcan du Tartaret"
            ,"/images/tartaretTile.jpg"
            , [ p  [] [text "Il est l´un des plus récents d´Auvergne. Ses
                             pentes boisées empêchent de distinguer son cratère mais
                             les sentiers qui le traverse sont des plus
                             agréables et accessibles. Parcours de santé et d'orientation
                             (cartes en vente à l'office de tourisme). "]
              ]
            )
            ,
            ("Lac Chambon"
            ,"/images/lacChambonTile.jpg"
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
            ("Grottes de Rageat"
            ,"/images/rajatTile.jpg"
            , [ p  [] [text "D'accès difficile, les falaises qui les abritent sont
                             composées d'un mélange de Bolts et argiles aux
                             couleurs pastel allant de l'ocre, vert ou rosé,
                             au bleuté. Ces habitations troglodytes sont très anciennes,
                             certainement antérieures à l'époque gauloise. Toutefois leur histoire
                             mal connue ne s'appuie que sur des hypothèses.
                             Ce site est un enchantement pour le promeneur
                             attentif et permet à celui qui s'y rend
                             de rêver et d'imaginer sa propre histoire. "]
              ]
            )
           ]
  }

 