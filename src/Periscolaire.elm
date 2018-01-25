module Periscolaire where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initAtWithLink,view,update,Action)
import StarTable exposing (makeTable, emptyTe, Label(..))
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)


-- Model
subMenu : Utils.Submenu
subMenu = { current = "", entries = []}

type alias MainContent = 
  { wrapper : (Html -> Bool -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Utils.Menu
  , subMenu     : Utils.Submenu
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
      [ renderMainMenu ["Vie locale", "Péri et extra-scolaire"]
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

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

port locationSearch : String

initialContent =
  { wrapper = 
    (\content showIntro ->
       div [ class "subContainerData noSubmenu", id "periscolaire"]
           [ h2 [] [ text "Péri et extra-scolaire"]
           , p  [classList [("intro",True),("displayIntro", showIntro)]] 
                [text "Les compétences péri et extrascolaires sont portées par 
                       le SIVOM de la Vallée Verte de la 
                       Couze Chambon qui regroupe les communes de Chambon 
                       sur Lac, Murol, Saint-Nectaire et Saint-Victor-la-Rivière. Sébastien GOUTTEBEL, 
                       le maire de Murol, est le président du 
                       SIVOM. "]
           , p [classList [("intro",True),("displayIntro", showIntro)]] 
               [text "Le secrétariat du SIVOM est assuré par Frédérique 
                     Heitz, dans les locaux de la mairie de 
                     Murol. Elle vous accueille les lundis, mardis et 
                     jeudis de 9h30 à 12h30 dans son bureau 
                     au 1er étage ou par téléphone au 04 
                     73 88 60 67. "]
           --, p [ classList [("intro",True),("displayIntro", showIntro)]]
           --    [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS MUROL 2017-2018.pdf"
           --        , target "_blank"]
           --        [ text "fiche de renseignements Murol"]
           --    ]
           --, p [ classList [("intro",True),("displayIntro", showIntro)]]
           --    [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS CHAMBON 2017 2018.pdf"
           --        , target "_blank"]
           --        [ text "fiche de renseignements Chambon"]
           --    ]
           --, p [ classList [("intro",True),("displayIntro", showIntro)]]
           --    [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS ST NECTAIRE 2017-2018.pdf"
           --        , target "_blank"]
           --        [ text "fiche de renseignements Saint-Nectaire"]
           --    ]
           --, p [ classList [("intro",True),("displayIntro", showIntro)]]
           --    [ a [ href "/baseDocumentaire/periscolaire/reglementCharte.pdf"
           --        , target "_blank"]
           --        [ text "règlement intérieur et charte du savoir vivre"]
           , p [ classList [("intro",True),("displayIntro", showIntro)]]
               [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS MUROL 2017-2018.pdf"
                   , target "_blank"]
                   [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Murol"]
                   ]
           , p [ classList [("intro",True),("displayIntro", showIntro)]]
               [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS CHAMBON 2017 2018.pdf"
                   , target "_blank"]
                   [ text "Dossier d’inscription SIVOM pour les enfants scolarisés au Chambon"]
               ]
           , p [ classList [("intro",True),("displayIntro", showIntro)]]
               [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS ST NECTAIRE 2017-2018.pdf"
                   , target "_blank"]
                   [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Saint-Nectaire"]
               ]
           , p [ classList [("intro",True),("displayIntro", showIntro)]]
               [ a [ href "/baseDocumentaire/periscolaire/Charte du SAVOIR VIVRE.pdf"
                   , target "_blank"]
                   [ text "Charte du savoir-vivre"]
               ]

           --, p [ classList [("intro",True),("displayIntro", showIntro)]]
           --    [ a [ href "/baseDocumentaire/periscolaire/REGLEMENT INTERIEUR ET TARIFS.pdf"
           --        , target "_blank"]
           --        [ text "règlement intérieur"]
           --    ]
           --, p [ classList [("intro",True),("displayIntro", showIntro)]]
           --    [ a [ href "/baseDocumentaire/periscolaire/Charte du SAVOIR VIVRE.pdf"
           --        , target "_blank"]
           --        [ text "charte du savoir vivre"]
           --    ]

           , content])
  , tiledMenu =
      initAtWithLink locationSearch peri
  }


-- Data
peri =
  [ ("Restaurant scolaire"
    ,"/images/tiles/periscolaire/restaurant scolaire.jpg"
    , [ p [] [ text "Le restaurant scolaire est un service non obligatoire 
                     assuré par le SIVOM de la Vallée Verte. 
                     Il accueille les enfants de la maternelle et 
                     de l’école élémentaire de Murol les lundis, mardis, 
                     jeudis et vendredis de 12h à 13h30. "]
      , p [] [ text "Les enfants déjeunent en deux services (petits puis 
                     grands) pour limiter le bruit dans le réfectoire. "]
      , p [] [ text "Les repas sont préparés sur place par la 
                     cuisinière du SIVOM, Monique Picot. Un repas «bio» 
                     est servi aux enfants une fois par mois. "]
      , p [] [ text "La surveillance est assurée par les personnels du 
                     SIVOM, Karine Fouquet, Emmanuelle Delorme et Florence Planeix. "]
      , p [] [ text "Les enfants sont tenus de se comporter correctement, 
                     selon les préconisations détaillées dans la charte du 
                     savoir-vivre et le règlement intérieur. En cas de 
                     problème de discipline, les parents sont informés par 
                     le biais d’avertissements remis aux enfants."]
      , p [] [ text "Si votre enfant présente des allergies alimentaires, un 
                     protocole devra être établi avant qu’il ne soit 
                     accueilli au restaurant scolaire (PAI). "]
      , p [] [ text "Le montant de la participation des familles est fonction des revenus
                     de celles-ci (tarification selon le quotient familial): "]
      , table [ id "quotient"]
              [ tr [ class "quotLine"]
                   [ td [] [ text "Quotient familial"]
                   , td [] [ text "de 0 à 350€"]
                   , td [] [ text "de 351 à 500€"]
                   , td [] [ text "de 501 à 600€"]
                   , td [] [ text "plus de 600€"]
                   ]
              , tr [ class "quotAltLine"]
                   [ td [] [ text "Tarif maternelle"]
                   , td [] [ text "2,00€"]
                   , td [] [ text "2,40€"]
                   , td [] [ text "2,70€"]
                   , td [] [ text "2,95€"]
                   ]
              , tr [ class "quotLine"]
                   [ td [] [ text "Tarif  élémentaire"]
                   , td [] [ text "2,00€"]
                   , td [] [ text "2,50€"]
                   , td [] [ text "2,85€"]
                   , td [] [ text "3,10€"]
                   ]
              ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS MUROL 2017-2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Murol"]
              ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS CHAMBON 2017 2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés au Chambon"]
          ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS ST NECTAIRE 2017-2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Saint-Nectaire"]
          ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/Charte du SAVOIR VIVRE.pdf"
              , target "_blank"]
              [ text "Charte du savoir-vivre"]
          ]
    ]
    ,"")
  , ("Garderie périscolaire"
    ,"/images/tiles/periscolaire/garderie.jpg"
    , [ p [] [text "La garderie périscolaire est un service non obligatoire 
                   assuré par le SIVOM de la Vallée Verte. 
                   Ce service est subventionné par la CAF et 
                   la MSA. "]
      , text "La garderie est ouverte: "
      , ul []
           [ li [] [text "le matin de 7h à 9h les lundis, 
                          mardis, mercredis, jeudis et vendredis"]
           , li [] [text "le soir de 16h30 à 19h les lundis, 
                          mardis, jeudis et vendredis. "]
           ]
      , p [] [text "La garderie accueille les enfants de la maternelle 
                   de Murol ainsi que des écoles élémentaires de 
                   Murol et de Chambon sur Lac. "]
      , p [] [text "Ils sont surveillés par Karine Fouquet (et Frédérique 
                    Heitz sur les créneaux de plus forte affluence). "]
      , p [] [text "La garderie est un temps de détente et 
                   de jeux libres. Mais pour le bien-être de 
                   tous, les enfants sont tenus de se comporter 
                   correctement, selon les préconisations détaillées dans la charte 
                   du savoir-vivre et le règlement intérieur. En cas 
                   de problème de discipline, les parents sont informés 
                   par le biais d’avertissements remis aux enfants. "]
      , text "La participation des familles est fonction des revenus 
              de celles-ci : "
      , ul []
           [ li [] [text "Familles non-imposables : 1,15€ de l’heure "]
           , li [] [text "Familles imposables : 1,35€ de l’heure "]
           ]
      , p [] [text "NB : le créneau 16h30/18h est facturé comme 
                    1 heure. "]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS MUROL 2017-2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Murol"]
              ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS CHAMBON 2017 2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés au Chambon"]
          ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS ST NECTAIRE 2017-2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Saint-Nectaire"]
          ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/Charte du SAVOIR VIVRE.pdf"
              , target "_blank"]
              [ text "Charte du savoir-vivre"]
          ]
      ]
    ,""
    )
  , ("Temps d'activités périscolaires (TAP)"
    ,"/images/tiles/periscolaire/TAP.jpg"
    ,[ p [] [text "L’organisation des activités périscolaires dans les quatre écoles 
                   de la vallée est réalisée par le SIVOM 
                   dans le cadre d’un projet éducatif territorial qui 
                   garantit un encadrement de qualité pour les enfants 
                   et une programmation qui répond à des objectifs 
                   éducatifs. Le financement est assuré par le SIVOM, 
                   l’Etat, la CAF et la participation des parents."]
     , p [] [text "Les enfants inscrits bénéficient de deux séances d’activités 
                   hebdomadaires: "]
     , table [ id "tableTAP"]
             [ tr []
                  [ th [] [text "ECOLE"]
                  , th [] [text "JOURS DE TAP"]
                  , th [] [text "HORAIRES DE TAP"]
                  , th [] [text "DIRECTION"]
                  , th [] [text "PROGRAMMES"]
                  ]
             , tr []
                  [ td [] [text "Maternelle de Murol"]
                  , td [] [text "Mardi et vendredi"]
                  , td [] [text "15h00 à 16h30"]
                  , td [] [text "Karine Fouquet"]
                  , td [] [a [href "/baseDocumentaire/periscolaire/PROGRAMME TAP MATERNELLE 2017 2018.pdf", target "_blank"] [text "maternelle"]]
                  ]
             , tr []
                  [ td [] [text "Elémentaire de Murol"]
                  , td [] [text "Lundi et jeudi"]
                  , td [] [text "15h00 à 16h30"]
                  , td [] [text "Frédérique Heitz"]
                  , td [] [a [href "/baseDocumentaire/periscolaire/TAP murol 2017 rentrée à toussaint-1.pdf", target "_blank"] [text "Murol"]]
                  ]
             , tr []
                  [ td [] [text "Elémentaire du Chambon"]
                  , td [] [text "Lundi et jeudi"]
                  , td [] [text "15h15 à 16h45"]
                  , td [] [text "Karine Fouquet"]
                  , td [] [a [href "/baseDocumentaire/periscolaire/PROGRAMME TAP CHAMBON 2017 2018.pdf", target "_blank"] [text "Chambon"]]
                  ]
             , tr []
                  [ td [] [text "Primaire de St Nectaire"]
                  , td [] [text "Mardi et vendredi"]
                  , td [] [text "15h00 à 16h30"]
                  , td [] [text "Frédérique Heitz"]
                  , td [] [a [href "/baseDocumentaire/periscolaire/TAP St Nect 2017 rentrée à toussaint-1.pdf", target "_blank"] [text "Saint-Nectaire"]]
                  ]  
             ]
     , p [] [text "L’inscription est annuelle et la participation
                   des familles est de 12€ par trimestre et par enfant."]   
     , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS MUROL 2017-2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Murol"]
              ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS CHAMBON 2017 2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés au Chambon"]
          ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/FICHE RENSEIGNEMENTS ST NECTAIRE 2017-2018.pdf"
              , target "_blank"]
              [ text "Dossier d’inscription SIVOM pour les enfants scolarisés à Saint-Nectaire"]
          ]
     
      
      --, p [ ]
      --    [ a [ href "/baseDocumentaire/periscolaire/TAP murol 2017 rentrée à toussaint-1.pdf"
      --        , target "_blank"]
      --        [ text "programme TAP Murol - rentrée à Toussaint"]
      --    ]

      --, p [ ]
      --    [ a [ href "/baseDocumentaire/periscolaire/PROGRAMME TAP CHAMBON 2017 2018.pdf"
      --        , target "_blank"]
      --        [ text "programme annuel TAP Chambon"]
      --    ]
      --, p [ ]
      --    [ a [ href "/baseDocumentaire/periscolaire/TAP St Nect 2017 rentrée à toussaint-1.pdf"
      --        , target "_blank"]
      --        [ text "programme TAP Saint-Nectaire - rentrée à Toussaint"]
      --    ]
      --, p [ ]
      --    [ a [ href "/baseDocumentaire/periscolaire/PROGRAMME TAP MATERNELLE 2017 2018.pdf"
      --        , target "_blank"]
      --        [ text "programme TAP Maternelle"]
      --    ]
      , p [ ]
          [ a [ href "/baseDocumentaire/periscolaire/PROJET PEDAGOGIQUE TAP 2017 2018.pdf"
              , target "_blank"]
              [ text "projet pédagogique TAP"]
          ]
     
     ]
    ,""
    )
  , ("Centre de loisirs"
    ,"/images/tiles/periscolaire/centre de loisirs.jpg"
    , [ p [] [text "Le Centre de Loisirs du SIVOM de la 
                   Vallée Verte propose d’accueillir les enfants des communes 
                   de Chambon sur Lac, Murol, Saint-Nectaire et Saint-Victor-la-Rivière, 
                   ayant 3 ans révolus 
                   et déjà inscrits dans un établissement scolaire."]
      , text "Il sera ouvert dans les locaux de l’école 
             maternelle de Murol du lundi au vendredi de 
             8h à 18h:"
      , ul []
           [ li [] [text "Du 12 au 23 février 2018"] 
           --li [] [text "Du 20 février au 3 mars 2017"]
           , li [] [text "Du 9 au 20 avril 2018"
                    
                   ]
           , li [] [text "Du 9 juillet au 24 août 2018"
                   ]
           
           ]
      --, p [] [ a [ href "/baseDocumentaire/periscolaire/PROJET PEDAGOGIQUE ET PROGRAMME JUILLET 2017.pdf", target "_blank"]
      --                [ text "programme des activités et projet pédagogique - Juillet 2017"]
      --            ]
      , p [] [ a [ href "/baseDocumentaire/periscolaire/programme fév 2018.pdf", target "_blank"]
                      [ text "programme des activités - Février 2018"]
                  ]

      , p [] [ a [ href "/baseDocumentaire/periscolaire/Projet Pédagogique Février 2018.pdf", target "_blank"]
                      [ text "projet pédagogique - Février 2018"]
                  ]
      , p [] [a [ href "/baseDocumentaire/periscolaire/plaquette fév  2018.pdf"
                , target "_blank"
                ]
                [ text "plaquette de présentation du centre de loisirs hiver" ]
             ]
      , p [] [ a [href "/baseDocumentaire/periscolaire/inscription prév février 2018", target "_blank"]
                 [text "la fiche d’inscription CLSH"]
             ]
                  
      , p [] [text "Des enfants d’autres communes d’origine, de la population 
                   touristique notamment, pourront être également accueillis, dans la 
                   limite des places disponibles. "]
      , p [] [text "Les familles pourront inscrire leurs enfants à la 
                   semaine, à la journée ou à la demi-journée 
                   avec ou sans repas. Un service de ramassage 
                   est assuré matin et soir. "]
      , p [] [text "Ce service est subventionné par la CAF et 
                   la MSA. La participation des familles est fonction 
                   des revenus de celles-ci ("
             ,a [href "/baseDocumentaire/periscolaire/TARIFS SIVOM 2017.pdf", target "_blank"]
                [text "tarifs selon le quotient 
                      familial"]
             ,text ")"    
             ]
      
      , text "Liens:"
      , p [] [a [href "/baseDocumentaire/periscolaire/PROJET EDUCATIF 2016.pdf", target "_blank"]
                [text "Projet éducatif du centre de loisirs du SIVOM de la Vallée Verte"]]
      
      --, p [] [a [href "/baseDocumentaire/periscolaire/PP avril 2017.pdf", target "_blank"]
      --          [text "Projet pédagogique vacances de printemps "]
      --       ]
      
      
      --, p [] [a [ href "/baseDocumentaire/periscolaire/plaquette CLSH 2017.pdf"
      --          , target "_blank"
      --          ]
      --          [ text "Tarifs SIVOM 2017" ]
      --       ]

      --, p [] [a [ href "/baseDocumentaire/periscolaire/plaquette 2017 centre de loisirs printemps.pdf"
      --          , target "_blank"
      --          ]
      --          [ text "Plaquette de présentation du centre de loisirs printemps" ]
      --       ]


      ]
    ,""
    )
  , ("Transport scolaire"
    ,"/images/tiles/periscolaire/navette.jpg"
    , [ 
      --p [] [ text "Pour le transport scolaire, la participation des familles 
      --             a été fixée forfaitairement par le Conseil Général 
      --             pour l’année scolaire 2008 / 2009 à 12,80€ 
      --             par mois (64€ par mois pour les élèves 
      --             non subventionnés)."] 
      ]
    ,"http://www.puy-de-dome.fr/transports/transports-scolaires/bus-scolaire.html"
    )
  , ("Activités jeunesse de la communauté de communes"
    ,"/images/tiles/periscolaire/actiJeunesse.jpg"
    ,[]
    ,"http://www.cc-massifdusancy.fr/enfance-jeunesse/activites-jeunesse_5675.cfm"
    )
  ]
  