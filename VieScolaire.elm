module VieScolaire where

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
                       mail,
                       site,
                       link)

-- Model
subMenu = [ "Ecole Maternelle"
          , "Ecole Elementaire"
          , "Le Secondaire"
          , "Periscolaire"
          ]

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ renderSubMenu address "Vie Scolaire:" (.subMenu model)
            , .mainContent model
            ]
      , pageFooter
      ]

-- Update

contentMap =
 fromList [ ("Ecole Maternelle",mater)
          , ("Ecole Elementaire", elem)
          , ("Le Secondaire", second)
          , ("Periscolaire", peri)
          ]

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

-- Miscs

nullTag = span [style [("display","none")]] []

-- Data

initialContent = 
    div [ class "subContainerData", id "initVieScolaire"]
        [ p [] [ text "Scolarisez vos enfants à Murol de la maternelle au primaire"]
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
     [ div [ class "schoolAddress"]
           [ p [] [ text "Ecole Maternelle"]
           , p [] [ text "Rue du Tartaret - 63790 Murol"]
           , p [] [ text "Tél : 04 73 88 64 70"]
           ]
     , p [] [ text "Les enfants peuvent y être accueillis à 3 
                    ans. Ils peuvent également être admis dans la 
                    limite des places disponibles s'ils ont atteint l'âge 
                    de 2 ans au jour de la rentrée 
                    scolaire, à condition qu'ils soient physiquement et psychologiquement 
                    prêts à la fréquenter."]
     , p [] [ text "Ils y restent jusqu'à la rentrée scolaire de l'année civile
                    au cours de laquelle ils atteignent l'âge de 6 ans."]
     , h4 [] [ text "Inscription"]
     , p  [] [ text "Prenez rendez-vous auprès de la directrice de la 
                     maternelle. Vos enfants seront inscrits directement par la 
                     directrice à l'école qui en profitera pour faire 
                     connaissance avec les parents et faire visiter l'école. "]
     , h5 [] [ text "Munissez vous des documents suivants :"]
     , ul [] [ li [] [ text "le livret de famille"]
             , li [] [ text "une carte d'identité ou une copie d'extrait d'acte de naissance"]
             , li [] [ text "un justificatif de domicile"]
             , li [] [ text "un document attestant que l'enfant a subi les 
                             vaccinations obligatoires pour son âge
                             (antidiphtérique, antitétanique, antipoliomyélitique)"]
             ]
     , h5 [] [ text "Enfants déjà scolarisés à Murol, Chambon, Saint Victor et Saint Nectaire:"]
     , p  [] [ text "Vous n'avez pas de démarches à effectuer si 
                     votre enfant est déjà scolarisé au sein du 
                     SIVOM de la Vallée Verte soit, de Murol, 
                     Chambon, Saint Victor la Rivière et Saint Nectaire;. 
                     L'école se charge de l' inscription de votre 
                     enfant pour la poursuite de sa scolarité dans 
                     le cadre du regroupement pédagogique intercommunal (RPI), de 
                     la Petite Section de maternelle au CM2."]
     , h4 [] [ text "Pause Douceur"]
     , p  [] [ text "Des séances de contes sont proposées le temps de la pause déjeuner au sein de l'école maternelle."]
     , p  [] [ text "Les dates et horaires seront précisées ultérieurement (renseignement à l'école)"]
     ]



        
elem   = 
  div [ class "subContainerData", id "elemVieScolaire"]
      [ div [ class "schoolAddress"] 
            [ p [] [ text "Ecole élémentaire"]
            , p [] [ text "Rue de l'hôtel de ville - 63790 Murol"]
            , p [] [ text "Tél : 04 73 88 62 91"]
            ]
      , h4 [] [ text "Inscription"]
      , h5 [] [ text "Vous êtes nouveaux sur la commune:"]
      , p  [] [ text "Allez à la mairie avec les documents suivants: "]
      , ul [] [ li [] [ text "le livret de famille"]
              , li [] [ text "une carte d'identité ou une copie d'extrait d'acte de naissance"]
              , li [] [ text "un justificatif de domicile"]
              , li [] [ text "un document attestant que l'enfant a subi les 
                              vaccinations obligatoires pour son âge
                              (antidiphtérique, antitétanique, antipoliomyélitique)"]
              ]
      , h5 [] [ text "Enfants déjà scolarisés à Murol, Chambon et Saint Victor"]
      , p  [] [ text "Vous n'avez pas de démarches à effectuer si 
                      votre enfant est déjà scolarisé au sein du 
                      SIVOM de la Vallée Verte soit, de Murol, 
                      Chambon et Saint Victor la Rivière;. L'école se 
                      charge de l' inscription de votre enfant pour 
                      la poursuite de sa scolarité dans le cadre 
                      du regroupement pédagogique intercommunal (RPI), du CP au 
                      CM2."]
      ]



second = 
  div [ class "subContainerData", id "secondVieScolaire"]
      [ div [ class "schoolAddress"] 
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

peri =
  div [ class "subContainerData", id "periVieScolaire"]
  [ p [] [ text "Les Chèques Emploi Service Universel sont dorénavant acceptés pour
                 le paiement de la garderie périscolaire."]
  , p [] [ text "En dehors des heures de classe, le SIVOM de la VALLEE VERTE propose
                 les services de garderie et de restaurant scolaire, selon les
                 horaires et les tarifs suivants: "]
  , p [] [ h6 [ class "periCat"] [text "Restaurant scolaire: "]
         , link "Fiche d'inscription" ""]
  , p [] [ text "ouvert de 12h00 à 13h30"]
  , p [] [ text " Le montant de la participation des familles est fonction des revenus
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
  , p [] [ text "Un repas « bio » sera servi aux enfants une fois par mois."]
  , p [] [ h6 [class "periCat"] [text "Garderie: "]
         , link "Fiche d'inscription" ""]
  , p [] [ text "ouverte de 7h00 à 9h00 et de 16h30 à 19h00 : 1,20€ de l’heure."]
  , p [] [ link "Charte du savoir-vivre" ""
         , text " en milieu scolaire et périscolaire"]
  , p [] [ link "Règlement intérieur" ""
         , text " du restaurant scolaire et de la garderie"]
  , h6 [class "periCat"] [text "Centre de loisirs"]
  , p [] [ text "Ouvert pendant les vacances scolaires"]
  , p [] [ text "Le centre de loisirs est ouvert du lundi au vendredi, dans les
                 locaux de l'école maternelle de Murol"]
  , p [] [ text "Inscription en mairie"]
  , h6 [class "periCat"] [text "Transport scolaire"]
  , p [] [ text "Pour le transport scolaire, la participation des familles 
                 a été fixée forfaitairement par le Conseil Général 
                 pour l’année scolaire 2008 / 2009 à 12,80€ 
                 par mois (64€ par mois pour les élèves 
                 non subventionnés)."] 
  ]  

