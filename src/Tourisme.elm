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
                       renderSubMenu,
                       mail)


--Model

subMenu = [ "Accueil Tourisme"
          , "Découvrir Murol"
          , "Hebergements"
          , "Restaurants"
          , "Carte & plan"
          , "Animation estivale" ]

initialContent =
  div [ class "subContainerData", id "initTourisme"]
      [ h2 [] [ text "Office de tourisme"]
      , p []
          [ text "Rue de jassaguet - 63790 Murol"]
      , p []
          [ text "Tel: 04-73-88-62-62"]
      , p []
          [ text "Fax : 04-73-88-60-23"]
      , mail "bt.murol-chambon@sancy.com"
      , p []
          [ text "Horaires : pendant les vacances, ouvert du lundi au samedi de 9h à 12 et de 14h à 18h.
                  Le reste de l’année, il est ouvert du lundi au samedi de 9h à 12h."]
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
          , ("Hebergements",hebergements)
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

addStars : Maybe Int -> String -> Html
addStars n s =
  let go n = if n == 0
             then ""
             else  "★" ++ go (n-1)
  in case n of
       Nothing -> text s
       Just n' ->
         span []
              [ text ( s ++ " ")
              , span [ class "stars"]
                     [ text (go n') ]
              ]

type Label = FamillePlus | NoLabel

type alias TableEntry =
   { name  : String
   , label : Label
   , stars : Maybe Int
   , refOt : String
   , descr : List String
   , addr  : String
   , tel   : String
   , fax   : String
   , mail  : String
   , site  : String
   , pics  : List String
   }
 
emptyTe = TableEntry "" NoLabel Nothing "" [] "" "" "" "" "" []

makeTable name entries =
  let
  makeRows b xs =
    case xs of
      [] -> []
      (e::xs') ->
        makeRow e b :: makeRows (not b) xs'
  in table [id name] (makeRows True entries)


makeRow : TableEntry -> Bool -> Html
makeRow { name, label, stars, refOt, descr,
           addr, tel, fax, mail, site, pics } alt =
  let name'  = h6 [] [addStars stars name]

      label' = labelToHtml label

      addr'  = maybeElem
                addr (\s -> p [] [text s])

      mail'  = maybeElem
                mail (\s -> p [] [text "e.mail: ", a [href s] [text s]])

      site'  = maybeElem
                site (\s -> p [] [text "site: ", a [href s] [text s]])

      descr' = List.map (\s -> p [] [text s]) descr

      refOt' = maybeElem
                refOt (\s -> p [] [text ("Référence OT: " ++ s)])

      tel'   = maybeElem
                tel (\s -> p [] [text ("Tel. " ++ s)])
      fax'   = maybeElem
                fax (\s -> p [] [text ("Fax : " ++ s)])

      pics'  = div [] (List.map (\s -> img [src s] []) pics)

      alt'   = if alt then "altLine" else "Line"

  in tr [ class alt']
        [ td []
             ( [ name', label', refOt'] ++ descr' ++
              [ addr', tel', fax', mail', site'] )
        , td [] [ pics']
        ]


maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

labelToHtml l =
  case l of
    NoLabel     -> nullTag
    FamillePlus -> nullTag

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
  div [ class "subContainerData", id "decouvTourisme"]
      [ h2 [] [text "Découvrir Murol"]
      , figure []
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
  div [ class "subContainerData", id "restosTourisme"]
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

      , h4 [] [ text "Nos Restaurants"]
      , h5 [] [ text "A Beaune le Froid"]
      , makeTable "restosBeaunes" restosBeaunes

      , h5 [] [ text "A Murol"]
      , makeTable "restosMurol" restosMurol

      , h4 [] [ text "Bar - Brasserie"]
      , makeTable "barBrasserie" barBrasserie

      , h4 [] [ text "Bar de Nuit"]
      , makeTable "barDeNuit" barDeNuit
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

carte =
  div [ class "subContainerData", id "carteTourisme"]
       [ p [] [ text "Coordonnées : Latitude / longitude N 45°34'34\" / E 002°56'34\" "]
       , p [] [ text "UTM : 31T 0495538 5046689 "]
       , p [] [ text "Situer Murol en cliquant sur la carte"]
       ,  iframe [ id "map", src "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2792.828421278047!2d2.9417002157517658!3d45.57388887910252!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNDXCsDM0JzI2LjAiTiAywrA1NiczOC4wIkU!5e0!3m2!1szh-TW!2stw!4v1449889280943"] []
      ]

hebergements = div [ class "subContainerData", id "hebergTourisme"]
                   [ h4 [] [ text "Nos Hotels"]
                   , p  [] [ text "Murol offre une grande diversité d'établissements, généralement indépendants. 
                                   Beaucoup d'entre eux se sont engagés dans des 
                                   démarches de qualité, symbolisées par différents labels. Certains 
                                   sont hôtels restaurants et offrent une prestation en 
                                   demi-pension et pension complète. "]
                   , makeTable "hotels" hotels
                   , h4 [] [ text "Nos Campings"]
                   , p  [] [ text "Ils offrent de bonnes conditions de confort et 
                                   beaucoup d'entre eux s'engagent dans des démarches de 
                                   qualité, symbolisées par différents labels. Certains d'entre eux 
                                   proposent également des locations de mobil-homes, chalets ou 
                                   bungalows."]
                   , makeTable "campings" campings
                   , h4 [] [ text "Nos Chambres d'Hôtes"]
                   , p  [] [ text "Elles répondent aux exigences actuelles de la clientèle, 
                                   en proposant des prestations de très bon confort. 
                                   Séjourner en chambre d'hôtes, c'est partager le quotidien 
                                   de personnes passionnées par leur région et attentives 
                                   à la qualité de l'accueil."]
                   , makeTable "chambresHotes" chambresHotes
                   , h4 [] [ text "Nos Meublés"]
                   , p  [] [ text "Très répandus dans le Massif du Sancy, ils 
                                   répondront à toutes les attentes et à tous 
                                   les budgets. Les meublés que nous vous proposons 
                                   sont tous classés par la préfecture. Le classement, 
                                   en étoiles, indique le degré de confort de 
                                   la location. Certains sont même labellisés. "]
                   , makeTable "meubles" meubles
                   , h4 [] [ text "Village Vacances"]
                   , makeTable "azureva" azureva
                   ]

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