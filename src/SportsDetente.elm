module SportsDetente where

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

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Culture et loisirs","Sports et détente"]
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
    _       -> model



--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  div [ class "subContainerData noSubmenu", id "sportsDetente"]
      [--[ h4 [] [text "Activité : YOGA"]
      --, p  [] [text "Des séances de Yoga hebdomadaires sont mises en place dans l'enceinte
      --               du centre Lignerat ou thermadore à St Nectaire tous les vendredis à 19h00."]
      --, p [] [text "Tarif : 10€ le cours d'une heure et demie. "]               
      --, p [] [text "renseignements sur place ou Association \"Créons Demain \""]
      --, p [] [text "Contact : "]
      --, p [] [text "Tél : 06 86 325 346 "]
      --, p [] [text "Mail  : isavey@wanadoo.fr"]
      --, p [] [text "Professeur : Isabelle Chassaniol"]

      
      --, h4 [] [text "Rugby tennis de table"]
      --, h4 [] [text "Qi gong gymnastique"]
      --, h4 [] [text "Ski de fond et raquettes"]
      --, h4 [] [text "Tennis multisports"]
      --, h4 [] [text "terrain de pétanque"]
        h4 [] [text "Equipements sportifs"]
      , p  [] [text "A Murol, les équipements sportifs de plein
                     air en accès libre sont nombreux :"]
      , ul []
           [ li [] [text "Boucles de randonnée "]
           , li [] [text "Parcours fixe de course d’orientation "]
           , li [] [text "Boucles de randonnée VTT "]
           , li [] [text "Domaine nordique "]
           , li [] [text "Site d’activités aquatiques et nautiques avec baignade surveillée 
                          l’été"]
           , li [] [text "Sites de pêche"]
           , li [] [text "Terrains de pétanque"]
           , li [] [text "Courts de tennis"]
           , li [] [text "Parcours sportif"]
           , li [] [text "Plateau multisports"]
           , li [] [text "Terrain de rugby "]
           , li [] [text "Terrain de volley "]
           ]

      , h4 [] [text "Activités sportives hebdomadaires"]
      , h5 [] [text "Rugby"]
      , text "Le XV de la Vallée Verte propose: "
      , ul []
           [li [] [text "une école de rugby pour les plus jeunes 
                         avec des entraînements le samedi après-midi "]
           ,li [] [text "une équipe adulte qui s’entraîne en soirée"]
           ]
      , p [] [ text "Renseignements : "
             , a [href "/Associations.html?bloc=01#LeXVdelaValléeVerte"]
                 [text "XV de la Vallée Verte"]
             ]
      
      , h5 [] [text "Tennis de table"]
      , p  [] [text "Chaque lundi soir à 20h à la salle 
                     des fêtes de Murol "]

      , h5 [] [text "Gymnastique d’entretien "]
      , p [] [ a [href "/Associations.html?bloc=01#Rencontreetdétente"]
                 [text "L’association rencontre et détente"]
             , text " organise des séances chaque 
                    lundi de 18h15 à 19h15 avec Sandrine Dalle. "    
             ]
      , p  [] [text "Tarif : 5€ la séance "]

      , h5 [] [text "Qi Gong"]
      , p  [] [text "Albine Carpentier anime des séances de Qi Gong 
                     tous les mercredis de 16h30 à 18h00 à 
                     la salle des fêtes de Murol. "]
      , p  [] [text "Les cours de cette année mêlent Qi Gong, 
                     étirements, entretien de la souplesse articulaire et musculaire, 
                     Soul Voice, expression libre de danse (biodanse), automassages 
                     ... "]
      , p  [] [text "D’autres activités sont proposées tout au long de 
                     l’année (méditations sonores, relaxation, randonnées, rencontres thématiques, échanges 
                     de recettes cuisine bio…) "]
      , p  [] [text "Renseignements auprès d’Albine Carpentier: "]
      , mail "albinesoleil@gmail.com"
      , p  [] [text "Téléphone : 06 13 78 87 27"]

      , h4 [] [text "Autres activités régulières"]
      
      , h5 [] [text "Chorale"]
      , p [] [ text "La chorale de "
             , a [href "/Associations.html?bloc=00#L'EnsembleInstrumentaldelaValléeVerte(EIVV)"]
                 [text "l’Ensemble Instrumental de la Vallée Verte"]
             , text " (EIVV) chante chaque mardi de 20h à 
                     22h à la salle des fêtes de Murol 
                     , sous la direction d’Annette BLATERON, le chef 
                     de chœur. Cette chorale regroupe une quarantaine de 
                     chanteurs, hommes et femmes, tous amateurs qui se 
                     répartissent en trois pupitres (soprano, alto et hommes). "    
             ]
      , p [] [text "Adhésion (participation annuelle) : 40€ "]

      , h5 [] [text "Tarot "]
      , p  [] [text "Des rencontres de joueurs de tarot ont lieu 
                     chaque 2ème vendredi du mois à 20h30 à 
                     la salle municipale en face de la poste. "]
      , p [] [ text "D’autres "
             , a [href "/Associations.html"]
                 [text "associations"]
             , text " organisent également des activités, n’hésitez pas 
                    à les contacter ! "    
             ]
      , br [] []
      , br [] []
      
      , contact

      ]

contact = 
   p []
     [ text "Liste non exhaustive, contactez "
     , a [href ("mailto:"++"contactsite.murol@orange.fr")]
         [text "le webmaster"]
     , text " pour toute erreur ou oubli!"
     ]