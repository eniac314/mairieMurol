module Tourisme where

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
                       renderSubMenu)


--Model

subMenu = [ "Accueil Tourisme"
          , "Découvrir Murol"
          , "Hebergements"
          , "Restaurants"
          , "Carte & plan"
          , "Animation estivale" ]

initialContent = 
  div [ class "subContainerData"]
      [ h4 [] [ text "Office de tourisme"]
      , p []
          [ text "Rue de jassaguet - 63790 Murol"]
      , p []
          [ text "Tel: 04-73-88-62-62"]
      , p []
          [ text "Fax : 04-73-88-60-23"]
      , p []
          [ text "Mail : bt.murol-chambon@sancy.com"]
      , p []
          [ text "Horaires : pendant les vacances, ouvert du lundi au samedi de 9h à 12 et de 14h à 18h. 
                  Le reste de l’année, il est ouvert du lundi au samedi de 9h à 12h."]    
      , renderListImg logos
      ]

initialModel = 
  { mainMenu    = mainMenu
  , subMenu     = subMenu 
  , mainContent = initialContent
  }

contentMap =
 fromList [ ("Découvrir Murol",decouvrir)
          , ("Accueil Tourisme", initialContent)
          , ("Restaurants", restaurants)
          , ("Carte & plan", carte)
          ]

--View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ renderSubMenu address "Tourisme:" (.subMenu model)
            , .mainContent model
            ]
      , pageFooter
      ]

makeTable name entries = 
  let 
  makeRows b xs =
    case xs of
      [] -> []
      ((n,a,m,s,d)::xs') ->
        makeRow n a m s d b :: makeRows (not b) xs'
  in table [id name] (makeRows True entries)

makeRow : String -> String -> String -> String -> List String -> Bool -> Html
makeRow  name adr mail site descr alt =
  let name' = h6 [] [text name]
      adr'  = 
        if String.isEmpty adr
        then nullTag
        else p [] [text adr]
      mail' =
        if String.isEmpty mail
        then nullTag
        else p []
               [ text "e.mail: "
               , a [href mail]
                   [text mail] 
               ]
      site' =
        if String.isEmpty site
        then nullTag
        else p []
               [ text "site: "
               , a [href site]
                   [text site] 
               ]
      descr' = List.map (\s -> p [] [text s]) descr
      alt'   = if alt then "altLine" else "Line"        
  in tr [class alt']
        ([name',adr',mail',site'] ++ descr')


nullTag = span [style [("display","none")]] []

--Update
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

--Data

decouvrir = 
  div [ class "subContainerData"]
      [ figure []
               [ img [src "/images/lac-et-chateau-de-murol.jpg"] []
               , br [] []
               , figcaption [] [text "Situé dans le massif du Sancy, 
                                     la commune de Murol est considérée 
                                     comme l'un des plus beaux 
                                     sites de l'Auvergne."]
               ]
      , p [] [ text "La commune appartient au canton de
                      Besse-et-Saint-Anastaise et est composée
                      de quatre villages, Murol, Beaune le froid,
                       Groire et Chautignat. Elle s'étend sur une
                        superficie de 15 km² à une altitude de 785m à 1500m."]
      , h3 [] [text "Les villages et hameaux"]
      , h4 [] [text "Murol"]
      , p  [] [text "Le bourg de Murol est implanté dans un écrin de verdure à
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
      , h4 [] [text "La desserte des principaux lieux touristiques"]
      , p  [] [text "Les visiteurs peuvent découvrir, sur le plan fourni 
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
      , h4 [] [ text "Beaune le froid"]
      , p  [] [ text "Petit village de montagne, deuxième bourg de la 
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
      , h4 [] [ text "Chautignat"]
      , p  [] [ text "Le hameau de Chautignat est situé à flanc 
                     de coteaux. Il bénéficie d'un ensoleillement maximum et 
                     de prairies aux pentes douces favorables à l'élevage 
                     comme aux cultures. A proximité du hameau se 
                     trouvent les grottes de Rajat et le moulin 
                     à eau de Landrode qui ont été les 
                     lieux de créations artistiques dans la cadre de 
                     la manifestation annuelle « Horizons rencontres Art et 
                     Nature ». "]
      , h4 [] [ text "Les hameaux des Ballats et Groire"]
      , p  [] [ text "Ces hameaux ont une activité rurale marquée, ils 
                     se situent là où le fond de la 
                     vallée s'élargit pour former de petites plaines propices 
                     aux cultures. Traversés par la Couze Chambon et 
                     les sentiers de randonnées, ils se prêtent à 
                     la flânerie. A l’occasion de la fête de 
                     Groire, le four à pain revit pour le 
                     plaisir des petits et grands gourmands. "]
      , h4 [] [ text "La Chassagne "]
      , p  [] [ text "Située sous le Château de Murol, La Chassagne 
                      est un hameau de fermes et maisons particulières. 
                      Ce lieu existait déjà sous Guillaume de Murol, 
                      seigneur du Château au début du XVème siècle. 
                      La légende raconte que Pierre Morand, \"concierge\" du 
                      château s'est installé ici et a fondé \"la 
                      Chassagne\". L'origine du nom vient des arbres présents 
                      à cette époque, les chênes. Aujourd'hui, quelques-uns subsistent 
                      sur les pentes du château, entrelacés avec les 
                      pins et autres arbustes. "]
      , h4 [] [text "Le volcan du Tartaret "]
      , p  [] [text "Il est l´un des plus récents d´Auvergne. Ses 
                     pentes boisées empêchent de distinguer son cratère mais 
                     les sentiers qui le traverse sont des plus 
                     agréables et accessibles. Parcours de santé et d'orientation 
                     (cartes en vente à l'office de tourisme). "]
      , h4 [] [text "Lac Chambon"]
      , p  [] [text "La partie Est du lac occupe la commune 
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
      , h4 [] [text "Grottes de Rageat"]
      , p  [] [text "D'accès difficile, les falaises qui les abritent sont 
                     composées d'un mélange de Bolts et argiles aux 
                     couleurs pastel allant de l'ocre, vert ou rosé, 
                     au bleuté. Ces habitations troglodytes sont très anciennes, 
                     certainement antérieures à l'époque gauloise. Toutefois leur histoire 
                     mal connue ne s'appuie que sur des hypothèses. 
                     Ce site est un enchantement pour le promeneur 
                     attentif et permet à celui qui s'y rend 
                     de rêver et d'imaginer sa propre histoire. "]  
      ]

restaurants = 
  div [ class "subContainerData"]
      [ p [] [ text "On ne peut évoquer l’Auvergne sans parler des 
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

      , h4 [] [ text "Nos Restaurants:"]
      , h5 [] [ text "A Beaune le Froid"]
      , restosBeaunes
      
      , h5 [] [ text "A Murol"]
      , restosMurol

      , h4 [] [ text "Bar - Brasserie"]
      , barBrasserie

      , h4 [] [ text "Bar de Nuit"]
      , barDeNuit 
    ]



restosBeaunes =
 makeTable "restosBeaunes"
  [ ("Les Sancy'Elles"
    ,"63790 Beaune le Froid -MUROL  Tél: 04 7388 8118"
    ,""
    ,""
    ,["Crèperie, petite restauration"]
    )
  ]

restosMurol = 
  makeTable "restosMurol"
    [ ("Au Montagnard"
      ,"Rue d'Estaing - 63790 MUROL Tél: 04 73 88 61 52 "
      ,"restaurant.aumontagnard@orange.fr"
      ,"http://restaurantaumontagnard.wifeo.com/"
      ,["Plat à emporter au restaurant"]
      )
      ,
      ("Chez Dame Galinette"
      ,"Rue d'Estaing - 63790 MUROL Tél: 04 73 88 61 52 "
      ,"murol@azureva-vacances.com"
      ,""
      ,[]
      )
      ,
      ("Le chalet de la plage"
      ,"lac Chambon - 63790 MUROL Tél : 04 73 88 82 31"
      ,"hotel@lac-chambon-plage.fr"
      ,""
      ,[]
      )
      ,
      ("Le Parc"
      ,"Rue Georges Sand - 63790 MUROL Tél: 04 73 88 60 08 fax : 04 73 88 64 44"
      ,"info@hotel-parc.com"
      ,""
      ,[]
      )
      ,
      ("Le Paris"
      ,"Pace de la mairie - 63790 MUROL Tél : 04 73 88 60 09 fax : 04 73 88 69 82"
      ,"info@hoteldeparis-murol.com"
      ,""
      ,[]
      )
      ,
      ("Le Piccotin \"Pizzéria\""
      ,"Rue Georges Sand - 63790 MUROL Tél : 04 73 62 37 10"
      ,""
      ,""
      ,[]
      )
    ]

barBrasserie = 
  makeTable "barBrasserie"
    [ ("A Jour et Nuit"
      ,"Rue Estaing - 63790 Murol Tél : 04 73 88 64 82"
      ,""
      ,""
      ,[]
      )
      ,
      ("Auberge de la plage"
      ,"La plage - 63790 Murol Tél : 04 73 88 67 90"
      ,""
      ,""
      ,[]
      )
      ,
      ("L'Arbalète"
      ,"Rue Georges Sand - 63790 MUROL Tél : 04 73 88 85 79"
      ,"restaurantlarbalete@gmail.com"
      ,""
      ,[]
      )
      ,
      ("Le café de la côte"
      ,"Rue Chabrol - 63790 MUROL - Tél : 06 7941 0811"
      ,""
      ,""
      ,["café- restaurant- herboristerie- salle de concert
        - atelier de confection de bougies
        en cire d'abeille, etc."
        ,"Bière locale, hypocras (entendez par là :
          vin aux épices médiéval), barbecue ."
        ,"L'ambiance ici est à la détente, et parfois à la
         fête puisque des concerts y sont
         organisés sporadiquement."
       ]
      )
    ]

barDeNuit = 
  makeTable "barDeNuit"
   [("Cubana café"
    ,"Place de la poste - 63790 MUROL Tél : 04 73 88 85 79"
    ,"larbalete@cegetel.net"
    ,""
    ,[]
    )
   ]

carte = 
  div [ class "subContainerData"]
      [ p [] [ text "Coordonnées : Latitude / longitude N 45°34'34\" / E 002°56'34\" "]
      , p [] [ text "UTM : 31T 0495538 5046689 "]
      , p [] [ text "Situer Murol en cliquant sur la carte"]
      , iframe [ id "map", src "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2792.828421278047!2d2.9417002157517658!3d45.57388887910252!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDXCsDM0JzI2LjAiTiAywrA1NiczOC4wIkU!5e0!3m2!1szh-TW!2stw!4v1449889280943"] []
      ]