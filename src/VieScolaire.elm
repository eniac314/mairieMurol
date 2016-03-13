module VieScolaire where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import SideMenu exposing (menuWithContextToContent, htmlToContent, init, view, update, Action)
import TiledMenu exposing (initAt)
import Murol exposing (mainMenu,
                       renderMainMenu',
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       mail,
                       site,
                       link)

-- Model
type alias Model =
  { mainMenu : Murol.Menu
  , sideMenu : SideMenu.Model
  } 
  

initialModel =
  { mainMenu = Murol.mainMenu
  , sideMenu = SideMenu.initAt
                  "Vie scolaire:"
                  "Accueil scolaire"
                  locationSearch

                  [ "Accueil scolaire"
                  , "Ecole maternelle"
                  , "Ecole élémentaire"
                  , "Le secondaire"
                  --, "Périscolaire"
                  ]
                  [ ("Accueil scolaire", htmlToContent vieScolaire)
                  , ("Ecole maternelle",htmlToContent mater)
                  , ("Ecole elementaire", htmlToContent elem)
                  , ("Le secondaire", htmlToContent second)
                  --, ("Périscolaire"
                  --  , menuWithContextToContent
                  --    (TiledMenu.initWithLink peri)
                  --    ( div []
                  --          [h2 [] [text "Périscolaire"]]
                  --    )
                  --  )
                  ]
  }

-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Vie locale", "Vie scolaire"] (.mainMenu model)
      , div [ id "subContainer"]
            [ SideMenu.view (Signal.forwardTo address SideMenuAction) (.sideMenu model)
            ]
      , pageFooter
      ]

-- Update

type Action = 
    NoOp
  | SideMenuAction (SideMenu.Action)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp    -> model
    SideMenuAction act ->
      { model |  sideMenu = SideMenu.update act (.sideMenu model) }


--Main

port locationSearch : String

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

-- Data



vieScolaire = 
    div [ class "subContainerData", id "initVieScolaire"]
        [ h2 [] [text "Vie scolaire"]
        , p [] [ text "Scolarisez vos enfants à Murol!"]
        , p [] [ text "Les enfants de 3 à 6 ans (dès 
                       2 ans si les effectifs le permettent) sont 
                       accueillis à la "
               , a [href "/VieScolaire.html?bloc=Ecole maternelle"]
                   [text "maternelle intercommunale de Murol"]
               , text ", rue du Tartaret, 63 790 MUROL."
               ]
        , p [] [text "Cette maternelle de deux classes accueille les enfants 
                     de Chambon sur Lac, Murol, Saint-Nectaire
                     et Saint-Victor-la-Rivière."]
       , p [] [ text "Les enfants poursuivent leur scolarité à "
              , a [href "/VieScolaire.html?bloc=Ecole elementaire"]
                  [text "l’école élémentaire de Murol"]
              , text ", place de l’Hôtel de Ville 63790 
                     MUROL, jusqu’à la fin du CE2. "
              ] 
        , p [] [text "Les enfants de CM1 et CM2 sont scolarisés 
                     à l’école de Chambon sur Lac. "]
        , p [] [text "Les écoles élémentaires de Murol et de Chambon 
                     sur Lac fonctionnent en Regroupement Pédagogique Intercommunal (RPI) 
                     et accueillent les enfants de Chambon sur Lac, 
                     Murol et Saint-Victor-la-Rivière. "]
        , p [] [ text "Le "
               , a [href "/VieScolaire.html?bloc=Le secondaire"]
                   [text "collège"]
               , text " du secteur se trouve à Besse 
                      et Saint-Anastaise."
               ]
        ,
        figure [ class "imgHolydays"]
               [ img [src "/images/carteZones.jpg"] []
               , img [src "/images/calendVac.jpg"] []
               , figcaption [] [ text "Vacances scolaires, répartition des zones et calendrier"
                               , br [] []
                               , a [ href "http://www.education.gouv.fr/cid87910/calendrier-scolaire-pour-les-annees-2015-2016-2016-2017-2017-2018.html"] [ text "source: education.gouv.fr"] ]
        ]
        ]


mater  =
 div [ class "subContainerData", id "materVieScolaire"]
     [ h2 [] [text "Ecole maternelle du SIVOM de la Vallée Verte"]
     , div [ class "schoolAddress"]
           [ p [] [ text "Ecole Maternelle"]
           , p [] [ text "Rue du Tartaret - 63790 Murol"]
           , p [] [ text "Tél : 04 73 88 64 70"]
           ]
     , p [] [text "Les locaux de la maternelle de Murol appartiennent 
                   au SIVOM de la Vallée Verte de la 
                   Couze Chambon, qui regroupe les communes de Chambon 
                   sur Lac, Murol, Saint-Nectaire et Saint-Victor-la-Rivière. Sébastien GOUTTEBEL, 
                   le maire de Murol, est le président du 
                   SIVOM. "]
     , p [] [text "La maternelle accueille les enfants des quatre communes 
                   du SIVOM dès l’âge de 2 ans, en 
                   fonction des places disponibles. "] 
     , p [] [text "La directrice de l’école maternelle se nomme Séverine 
                   AUBOUIN. "]

    , h5 [] [text "Année scolaire 2015 - 2016"]
    , p  [] [text "Répartition des classes : "]
    , ul []
         [ li  [] [text "Classe des petits et moyens : Sandrine GIDON et Céline GAILLARD"]
         , li  [] [text "Classe des moyens et grands : Séverine AUBOUIN."]
         ] 
    
    , p  [] [text "Horaires de classe (suite à la réforme des rythmes scolaires):"]
     --, p [] [ text "Les enfants peuvent y être accueillis à 3 
     --               ans. Ils peuvent également être admis dans la 
     --               limite des places disponibles s'ils ont atteint l'âge 
     --               de 2 ans au jour de la rentrée 
     --               scolaire, à condition qu'ils soient physiquement et psychologiquement 
     --               prêts à la fréquenter."]
     --, p [] [ text "Ils y restent jusqu'à la rentrée scolaire de l'année civile
     --               au cours de laquelle ils atteignent l'âge de 6 ans."]
     
     , table 
        [] [ tr []
                [ th [] []
                , th [colspan 3] [text "MATIN"]
                , th [rowspan 7, style [("width","3em")]] []
                , th [colspan 3] [text "APRES-MIDI"]
                ]
           , tr []
                [ td [] [text "Jours"]
                , td [] [text "Accueil"]
                , td [] [text "Début de la classe"]
                , td [] [text "Fin de la classe"]
                , td [] [text "Accueil"]
                , td [] [text "Début de la classe"]
                , td [] [text "Fin de la classe"]
                ]
           , tr []
                [ td [] [text "LUNDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "16h30"]
                ]
           , tr []
                [ td [] [text "MARDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "15h00*"]
                ]
          , tr []
                [ td [] [text "MERCREDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] []
                , td [] []
                , td [] []
                ]
          , tr []
                [ td [] [text "JEUDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "16h30"]
                ]
          , tr []
                [ td [] [text "VENDREDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "15h00*"]
                ]
           ]
     , p [] [ text "*Des "
            , a [href "/PériEtExtra-scolaire.html?bloc=2"]
                [text "Temps d’Activités Périscolaires"]
            , text "(TAP) sont organisés de 15h00 à 16h30 par le
                   SIVOM de la vallée verte pour les enfants."
            ]
      , p [] [text "Le projet d’école : il se poursuit avec, comme axes prioritaires,
                   la maîtrise de la langue, l’apprentissage du vivre
                   ensemble et de l’autonomie, ainsi que l’ouverture culturelle."]
      , h4 [] [ text "Inscription"]
      , p  [] [ text "Les inscriptions pour la rentrée de septembre 2016 
                     sont possibles dès maintenant. Prenez rendez-vous auprès de 
                     la directrice Séverine AUBOUIN au 04 73 88 
                     64 70. "]
      , text "Pour inscrire votre enfant à la maternelle vous 
              aurez besoin: "
      , ul []
           [ li [] [text "du livret de famille"]
           , li [] [text "du carnet de santé de l’enfant (vaccinations obligatoires)"]
           , li [] [text "d’un justificatif de domicile récent"]
           ]
      , p [style [("font-style", "oblique")]]
             [ b [] [text "Attention! "]
             , text "En raison de la forte fréquentation 
                     de la maternelle, les enfants de 2 ans 
                     seront inscrits sur liste d’attente. Ils seront accueillis 
                     en fonction des places disponibles. "
             ]

     --, p  [] [ text "Prenez rendez-vous auprès de la directrice de la 
     --                maternelle. Vos enfants seront inscrits directement par la 
     --                directrice à l'école qui en profitera pour faire 
     --                connaissance avec les parents et faire visiter l'école. "]
     --, h5 [] [ text "Munissez vous des documents suivants :"]
     --, ul [] [ li [] [ text "le livret de famille"]
     --        , li [] [ text "une carte d'identité ou une copie d'extrait d'acte de naissance"]
     --        , li [] [ text "un justificatif de domicile"]
     --        , li [] [ text "un document attestant que l'enfant a subi les 
     --                        vaccinations obligatoires pour son âge
     --                        (antidiphtérique, antitétanique, antipoliomyélitique)"]
     --        ]
     --, h5 [] [ text "Enfants déjà scolarisés à Murol, Chambon, Saint Victor et Saint Nectaire:"]
     --, p  [] [ text "Vous n'avez pas de démarches à effectuer si 
     --                votre enfant est déjà scolarisé au sein du 
     --                SIVOM de la Vallée Verte soit, de Murol, 
     --                Chambon, Saint Victor la Rivière et Saint Nectaire;. 
     --                L'école se charge de l' inscription de votre 
     --                enfant pour la poursuite de sa scolarité dans 
     --                le cadre du regroupement pédagogique intercommunal (RPI), de 
     --                la Petite Section de maternelle au CM2."]
     , h4 [] [ text "OPERATION « UN FRUIT POUR LA RECRE»"]
     , p  [] [text "Depuis la rentrée de septembre 2012, les deux 
                   classes de maternelle participent au projet « un 
                   fruit pour la récré ». "]
     , p  [] [text "Chaque semaine, les enfants dégustent un fruit de 
                   saison ou exotique dans le cadre d’un atelier 
                   d’éveil au goût organisé en classe. Des activités 
                   pédagogiques diversifiées accompagnent cette action. "]
     , p  [] [text "Cette opération, générée par le ministère de l’agriculture, 
                   est financée par le SIVOM de la Vallée 
                   Verte et des subventions européennes."]
     ]



        
elem   = 
  div [ class "subContainerData", id "elemVieScolaire"]
      [ h2 [] [text "Ecole élémentaire du Regroupement Pédagogique Intercommunal (RPI)"]
      , div [ class "schoolAddress"] 
            [ p [] [ text "Ecole élémentaire"]
            , p [] [ text "Rue de l'hôtel de ville - 63790 Murol"]
            , p [] [ text "Tél : 04 73 88 62 91"]
            ]
      , p [] [text "L’école élémentaire de Murol fonctionne en RPI avec 
                   l’école de Chambon sur Lac. "]
      , p [] [text "A Murol, sont accueillis les enfants de Chambon 
                   sur Lac, Murol et Saint-Victor la Rivière du 
                   CP au CE2 inclus. La directrice de l’école 
                   élémentaire de Murol se nomme Corinne AUBERTY. "]
      , p [] [text "Les enfants de CM1 et CM2 sont accueillis 
                   à l’école de Chambon sur Lac. "]

      , p [] [text "Le directeur de l’école de Chambon sur Lac 
                    se nomme Claude BOURRET."]

      , h5 [] [text "Année scolaire 2015 2016 "] 
      , p [] [text "Répartition des classes : "]
      , ul []
           [ li [] [text "Classe des CP: Marion VERDE et Elisabeth 
                          TAMET"]
           , li [] [text "Classe des CE1 / CE2: Corinne AUBERTY "]
           , li [] [text "Classe des CM1 / CM2 (Chambon sur Lac):
                          Claude BOURRET"]
           ]
      
      , p [] [text "Horaires de classe à l’école de Murol (suite 
                   à la réforme des rythmes scolaires) :"]

      , table 
        [] [ tr []
                [ th [] []
                , th [colspan 3] [text "MATIN"]
                , th [rowspan 7, style [("width","3em")]] []
                , th [colspan 3] [text "APRES-MIDI"]
                ]
           , tr []
                [ td [] [text "Jours"]
                , td [] [text "Accueil"]
                , td [] [text "Début de la classe"]
                , td [] [text "Fin de la classe"]
                , td [] [text "Accueil"]
                , td [] [text "Début de la classe"]
                , td [] [text "Fin de la classe"]
                ]
           , tr []
                [ td [] [text "LUNDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "15h00*"]
                ]
            , tr []
                [ td [] [text "MARDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "16h30"]
                ]
            , tr []
                [ td [] [text "MERCREDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] []
                , td [] []
                , td [] []
                ]
            , tr []
                [ td [] [text "JEUDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "15h00*"]
                ]
            , tr []
                [ td [] [text "VENDREDI"]
                , td [] [text "8h50"]
                , td [] [text "9h00"]
                , td [] [text "12h00"]
                , td [] [text "13h20"]
                , td [] [text "13h30"]
                , td [] [text "16h30"]
                ]
           ]      
      , p [] [ text "*Des "
            , a [href "/PériEtExtra-scolaire.html?bloc=2"]
                [text "Temps d’Activités Périscolaires"]
            , text "(TAP) sont organisés de 15h00 à 16h30 par le
                   SIVOM de la vallée verte pour les enfants."
            ]

      , p [] [text "Horaires de classe à l’école de Chambon
                    sur Lac (suite à la réforme des rythmes scolaires) :"]
      , table 
        [] [ tr []
                [ th [] []
                , th [colspan 3] [text "MATIN"]
                , th [rowspan 7, style [("width","3em")]] []
                , th [colspan 3] [text "APRES-MIDI"]
                ]
           , tr []
                [ td [] [text "Jours"]
                , td [] [text "Accueil"]
                , td [] [text "Début de la classe"]
                , td [] [text "Fin de la classe"]
                , td [] [text "Accueil"]
                , td [] [text "Début de la classe"]
                , td [] [text "Fin de la classe"]
                ]
           , tr []
                [ td [] [text "LUNDI"]
                , td [] [text "9h05"]
                , td [] [text "9h15"]
                , td [] [text "12h05"]
                , td [] [text "13h25"]
                , td [] [text "13h35"]
                , td [] [text "15h15*"]
                ]
            , tr []
                [ td [] [text "MARDI"]
                , td [] [text "9h05"]
                , td [] [text "9h15"]
                , td [] [text "12h05"]
                , td [] [text "13h25"]
                , td [] [text "13h35"]
                , td [] [text "16h45"]
                ]
            , tr []
                [ td [] [text "MERCREDI"]
                , td [] [text "9h05"]
                , td [] [text "9h15"]
                , td [] [text "12h15"]
                , td [] []
                , td [] []
                , td [] []
                ]
            , tr []
                [ td [] [text "JEUDI"]
                , td [] [text "9h05"]
                , td [] [text "9h15"]
                , td [] [text "12h05"]
                , td [] [text "13h25"]
                , td [] [text "13h35"]
                , td [] [text "15h15*"]
                ]
            , tr []
                [ td [] [text "VENDREDI"]
                , td [] [text "9h05"]
                , td [] [text "9h15"]
                , td [] [text "12h05"]
                , td [] [text "13h25"]
                , td [] [text "13h35"]
                , td [] [text "16h45"]
                ]
           ]
      
      , p [] [ text "*Des "
            , a [href "/PériEtExtra-scolaire.html?bloc=2"]
                [text "Temps d’Activités Périscolaires"]
            , text "(TAP) sont organisés de 15h15 à 16h45 par le
                   SIVOM  de la vallée verte pour les enfants."
            ]
      
      , p [] [text "Projet d’écoles : les axes prioritaires sont
                   l’orthographe, le vocabulaire, la production d’écrits,
                   la lecture oralisée, la compréhension de textes
                   et la résolution de problèmes."]

      , h4 [] [ text "Inscription"]
      , p  [] [ b [] [text "Vous êtes nouveaux sur la commune:"]]
      , p  [] [ text "Allez à la mairie avec les documents suivants: "]
      , ul [] [ li [] [ text "le livret de famille"]
              , li [] [ text "une carte d'identité ou une copie d'extrait d'acte de naissance"]
              , li [] [ text "un justificatif de domicile"]
              , li [] [ text "le carnet de santé de l’enfant (vaccinations obligatoires)"]
              ]
      , p  [] [ b [] [text "Enfants déjà scolarisés à Murol, Chambon et Saint Victor:"]]
      , p  [] [ text "Vous n'avez pas de démarches à effectuer si 
                     votre enfant est déjà scolarisé à la maternelle 
                     de Murol ou dans les écoles élémentaires de 
                     Murol et de Chambon sur Lac : les 
                     directeurs des écoles se chargent de l'inscription automatique 
                     de votre enfant pour la poursuite de sa 
                     scolarité de la maternelle au CM2 au sein 
                     du Regroupement Pédagogique Intercommunal (RPI). "]
      , p [] [text "NB : Si vous habitez Saint-Nectaire et que 
                   votre enfant est scolarisé à la maternelle de 
                   Murol, il poursuivra sa scolarité à l’école primaire 
                   de Saint-Nectaire. Dans ce cas, prendre contact avec 
                   la directrice de l’école de Saint-Nectaire avant le 
                   passage au CP. "]
      ]



second = 
  div [ class "subContainerData", id "secondVieScolaire"]
      [ h2 [] [text "Le secondaire"]
      , div [ class "schoolAddress"] 
            [ p [] [ text "Collège du Pavin"]
            , p [] [ text "Rue des Prés de la ville"]
            , p [] [ text "63610 - Besse et Saint Anastaise"]
            , p [] [ text "Tél : 04 73 79 52 74"]
            , p [] [ text "Fax : 04 73 79 57 94"]
            ]
      , mail "ce.0630008S@ac.clermont.fr"
      , br [] []
      , site "Collège du Pavin"
             "http://www.clg-pavin.ac-clermont.fr/"
      , h4 [] [ text "Inscription"]
      , site "Informations inscriptions"
             "http://www.education.gouv.fr/cid79/inscription.html#inscription-en-6e"
      ]

--peri =
--  [ ("Restaurant scolaire"
--    ,""
--    , [ link "Fiche d'inscription" ""
--      , p [] [ text "ouvert de 12h00 à 13h30"]
--      , p [] [ text " Le montant de la participation des familles est fonction des revenus
--                      de celles-ci (tarification selon le quotient familial): "]
--      , table [ id "quotient"]
--              [ tr [ class "quotLine"]
--                   [ td [] [ text "Quotient familial"]
--                   , td [] [ text "de 0 à 350€"]
--                   , td [] [ text "de 351 à 500€"]
--                   , td [] [ text "de 501 à 600€"]
--                   , td [] [ text "plus de 600€"]
--                   ]
--              , tr [ class "quotAltLine"]
--                   [ td [] [ text "Tarif maternelle"]
--                   , td [] [ text "2,00€"]
--                   , td [] [ text "2,40€"]
--                   , td [] [ text "2,70€"]
--                   , td [] [ text "2,95€"]
--                   ]
--              , tr [ class "quotLine"]
--                   [ td [] [ text "Tarif  élémentaire"]
--                   , td [] [ text "2,00€"]
--                   , td [] [ text "2,50€"]
--                   , td [] [ text "2,85€"]
--                   , td [] [ text "3,10€"]
--                   ]
--              ]
--      , p [] [ text "Un repas « bio » sera servi aux enfants une fois par mois."]
--      ]
--    ,"")
--  , ("Garderie périscolaire"
--    ,""
--    , [  p [] [ text "Les Chèques Emploi Service Universel sont dorénavant acceptés pour
--                    le paiement de la garderie périscolaire."]
--      , link "Fiche d'inscription" ""
--      , p [] [ text "ouverte de 7h00 à 9h00 et de 16h30 à 19h00 : 1,20€ de l’heure."]
--      , p [] [ link "Charte du savoir-vivre" ""
--             , text " en milieu scolaire et périscolaire"]
--      , p [] [ link "Règlement intérieur" ""
--             , text " du restaurant scolaire et de la garderie"] 
--     ]
--    ,""
--    )
--  , ("Temps d'activités périscolaires (TAP)"
--    ,""
--    ,[]
--    ,""
--    )
--  , ("Centre de loisirs"
--    ,""
--    , [ p [] [ text "Ouvert pendant les vacances scolaires"]
--      , p [] [ text "Le centre de loisirs est ouvert du lundi au vendredi, dans les
--                     locaux de l'école maternelle de Murol"]
--      , p [] [ text "Inscription en mairie"]
--      ]
--    ,""
--    )
--  , ("Transport scolaire"
--    ,""
--    , [ p [] [ text "Pour le transport scolaire, la participation des familles 
--                   a été fixée forfaitairement par le Conseil Général 
--                   pour l’année scolaire 2008 / 2009 à 12,80€ 
--                   par mois (64€ par mois pour les élèves 
--                   non subventionnés)."] 
--      ]
--    ,""
--    )
--  , ("Activités jeunesse de la communauté de communes"
--    ,""
--    ,[]
--    ," http://www.cc-massifdusancy.fr/"
--    )
--  ]
--  