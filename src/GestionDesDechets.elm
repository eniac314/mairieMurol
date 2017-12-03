module GestionDesDechets where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       
                       capitalize,
                       renderListImg,
                       logos,
                       Action (..),
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu
                      ["Vie locale", "Gestion des déchets"]
                      (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

-- Update

contentMap =
 fromList []

update action model =
  case action of
    NoOp    -> model
    Entry s -> changeMain model s

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

initialContent = 
  div [ class "subContainerData noSubmenu", id "initDechets"]
      [ h2 [] [text "La gestion des déchets"]
        , h5 [ class "trashCat"] [ text "Ramassage des ordures"]
        , p [] [text "Pour la période automne jusqu’au 30 décembre 2017
                     , la collecte est effectuée telle que :"
               ]
        , ul []
             [ li [] [text "Ordures ménagères : deux fois par semaine, le lundi et vendredi matin"]
             , li [] [text "Tri sélectif : le mercredi, une fois par semaine"]
             ]

        --, p  [] [ text "Le ramassage des ordures a lieu le: "]
        --, ul []
        --     [ li [] [text "lundi pour les ordures ménagères"]
        --     , li [] [text "le mercredi pour le tri sélectif \"poubelles jaunes\""]
        --     ]
        , h5 [ class "trashCat"] [ text "Objets encombrants"]
        , p  [] [ text "La municipalité souhaite aider les personnes n’ayant pas 
                        les moyens matériels nécessaires pour évacuer leurs objets 
                        encombrants en organisant des ramassages groupés."]
        , p [] [ text "Pour vous inscrire, merci de téléphoner à la mairie
                       au 04 73 88 60 67, afin que la municipalité puisse
                       programmer un ramassage dès que les demandes seront suffisantes."]
        , h5 [ class "trashCat"] [ text "Déchets verts"]
        , p  [] [ text "Les déchets verts (tontes, branches et même troncs débités)
                        doivent être apportés au SICTOM DES COUZES à St Diéry."]
        , p  [] [ text "Ils ne doivent pas être déposés ni brûlés sur le site de  RABACHOT."]
        , h5 [ class "trashCat"] [ text "Déchèteries"]
        , p  [] [ text "La plus proche est celle de Besse"]
        , ul []
             [ li [] [text "Fermée jeudi et dimanche"]
             , li [] [text "Lundi mercredi vendredi et samedi : 9h-12h / 14h-18h"]
             , li [] [text "Mardi : 8h-12h / 14h/17h"]
             ]
        , p [] [text "Autre possibilité : la déchèterie de Montaigut le Blanc"]
        , ul []
             [ li [] [text "Fermée lundi et dimanche"]
             , li [] [text "Mardi au samedi : 9h-12h / 14h-18"]
             ]
        , h5 [ class "trashCat"] [ text "La collecte des déchets recyclables"]
        , p  [] [ text "Le tri des déchets sur la commune de Murol se fait selon 4 possibilités :"]
        , ol []
             [ li []
                  [ h6 [] [ text "Les points d’apport volontaire"]
                  , p  [] [ text "Deux points d’apport volontaire, ou points propres, sont présents
                                  sur la commune : l’un dans le bourg et l’autre à Beaune le froid."]
                  , p  [] [ text "Plusieurs colonnes ou bacs y sont installés, pour séparer
                                  différents matériaux :"]
                  , ul []
                       [ li []
                            [ p [] [text "Le verre : uniquement pour les bouteilles et bocaux vides."]
                            , p [class "forbidden"] [text "Sont interdits : ampoules, miroirs, vitres cassées, vaisselle."]
                            , p [] [text "Il est préférable d’enlever les bouchons et couvercles métalliques."]
                            ]
                       , li []
                            [ p [] [text "Les papiers et cartons:"]
                            , p [] [text "pour le papier, la publicité, journaux et magazines,
                                          mais aussi le carton à condition qu’il soit plié."]
                            , p [class "forbidden"] [text "Sont interdits : les papiers et cartons souillés."]              
                            ]
                       , li []
                            [ p [] [text "Les corps « creux »:"]
                            , p [] [text " bouteilles plastiques, boîtes de conserve, aérosols et briques alimentaires."]
                            , p [class "forbidden"] [text "Sont interdits : les plastiques autres que les bouteilles
                                                              (le polystyrène, sacs, sachets alimentaires)"]
                            ]
                       , li [] 
                            [ p [] [text "L’huile de vidange :"]
                            , p [] [text "seule l’huile de vidange est acceptée. Il est possible de laisser le contenant
                                          (bidon) dans le casier réservé à cet effet (intégré à la colonne)."]
                            , p [class "forbidden"] [text "Il est interdit d’y déposer les huiles de friture, ainsi
                                                           que torchons, filtres à huiles ou autres objets pouvant
                                                           gêner l’utilisation de la colonne."]
                            ]
                       , li []
                            [ p [] [text "Les piles:"]
                            , p [] [text "une poubelle rouge est prévue à cet effet. Il est possible d’y déposer
                                          tout type de pile (hors batterie auto)."]
                            ]
                       ]

             , li [] [ h6 [] [ text "Les colonnes à Verre"]
                     , p  [] [ text "Outre les deux points d’apport volontaires, huit colonnes 
                                     à verre sont réparties sur le territoire :Vival 
                                     de Murol, camping de la Plage, tennis (route 
                                     de Besse), La Chassagne, camping de l’Europe, Groire, 
                                     camping des Fougères, et à Beaune le Froid."]
                     ]     
            
             , li [] [ h6 [] [text "Les bacs jaunes"]
                     , p  [] [text "A l’automne 2004, le SICTOM des Couzes a mis en
                                    place la collecte sélective des déchets d’emballages
                                    recyclables en bacs à couvercles jaunes. Cela concerne
                                    le bourg de Murol."]
                     , p [] [text "Les habitants font alors le tri à domicile et vont vider
                                   les déchets dans les bacs jaunes dispersés dans le bourg."]
                     , p [] [text "Sont acceptés:"]
                     , ul []
                          [ li [] [text "Les emballages plastiques : bouteilles UNIQUEMENT"]
                          , li [] [text "Les emballages cartons : propres et pliés pour ne pas encombrer le bac"]
                          , li [] [text "Les papiers, journaux et magazines"]
                          , li [] [text "Les emballages métalliques: : boites de conserve, aérosols, canettes…vides !"]
                          ]
                     , p [class "forbidden"] [text "Sont interdits : les sacs et films plastiques, jouets, polystyrène, pots de produits laitiers."]
                     ]

             , li [] [ h6 [] [text "Déposez en déchèterie:"]
                     , ul []
                          [ li [] [text "Les encombrants (meubles, lavabos, …)"]
                          , li [] [text "les déchets électriques (micro-ondes, électro ménager …)"]
                          , li [] [text "les déchets spéciaux (peintures, produits chimiques …)"]
                          , li [] [text "les déchets verts (gazons, tailles de haies…)"]
                          ]
                     ]       
                 ] 
             ]
        , br [] []
        , p  [] [text "Au moindre doute, il est préférable de jeter le déchet dans la poubelle traditionnelle."]             
      ]