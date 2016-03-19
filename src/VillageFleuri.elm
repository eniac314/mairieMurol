module VillageFleuri where

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

initialModel =
  { mainMenu    = mainMenu
  , mainContent = initialContent
  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu ["Documentation","Village fleuri"]
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
  div [ class "subContainerData noSubmenu", id "villageFleuri"]
      [ h2 [] [text "Le concours des villes et villages fleuris"]
      , div [id "compteRendu"]
            [ link "Compte rendu visite du jury en 2014" "/baseDocumentaire/villageFleuri/compteRenduJury2014.pdf"
            , img [src "/images/Village fleuri.jpg"] []
            , br  [] []
            , link " Téléchargez la fiche de présentation (PDF)" "/baseDocumentaire/villageFleuri/presentationFR.pdf"
            ]
           
      , h4 [] [text "L'organisation"]
      , p  [] [text "Le concours, qui a pour vocation de promouvoir 
                     et d'encourager toute action en faveur du développement 
                     des espaces verts et de l'amélioration du cadre 
                     de vie, consiste à attribuer une série de 
                     Fleurs (de une à quatre) correspondant au label 
                     ou à la marque \"Villes et Villages Fleuris 
                     \". "]
      , p [] [text "Un Grand Prix est attribué par le Jury 
                   National afin de distinguer les communes proposant des 
                   aménagements exceptionnels."]
      , p [] [text "Ces Fleurs sont apposées sur une signalétique spécifique 
                   représentée par un panneau à l'entrée de la 
                   commune. "]
      , p [] [text " National, gratuit et ouvert à toutes les communes,
                     le concours se déroule à plusieurs échelons (voir schéma ci-contre):"]
      , img [src "schema"] []
      , p [] [text "Dans le cadre de la loi de décentralisation et à partir de 1988,
                    le concours est organisé avec le soutien des départements et des régions."]
      
      , h4 [] [text "L'inscription"]
      , p  [] [text "Elle se fait auprès de la structure départementale 
                     chargée de recueillir les inscriptions des communes, et 
                     d'organiser le concours départemental à l'issu duquel une 
                     sélection sera proposée à la région pour l'attribution 
                     de la première fleur. "]

      , h4 [] [text "Le règlement"]
      , p  [] [text "Le règlement du concours est édité par le 
                     Conseil National des Villes et Villages Fleuris et 
                     diffusé sur l'ensemble des communes du territoire national 
                     et des DOM / TOM par les structures 
                     départementales chargées du concours."]
      , link "Règlement (pdf)" "/baseDocumentaire/villageFleuri/reglement.pdf"
      
      , h4 [] [text "Les évolutions du concours"]
      , p  [] [text "Durant les quarantes dernières années, le concours n'a 
                     cessé d'évoluer : "]
      , p  [] [text "Tout d'abord, une évolution quantitative, avec une progression 
                     très importante du nombre de communes inscrites, et 
                     du nombre de communes labellisées. "]
      , p  [] [text "Lors de sa création en 1959, 600 communes 
                     s'engagent dans le démarche."]
      , p  [] [text "En 1972, 5300 communes sont inscrites au concours, 
                     la barre des 10 000 est passée en 
                     1993 pour atteindre les 12 000 en 2005. 
                     "]
      , p  [] [text "Évolution également qualitative en ce qui concerne les 
                     critères d'évaluation. Depuis les assises de Bourges, en 
                     novembre 1996, les critères se sont élargis à 
                     l'ensemble des domaines qui s'inscrivent dans une politique 
                     globale d'aménagement. "]
      , p [] [text "Cette évolution a suivi celle des espaces verts 
                   qui ont également pris une place de plus 
                   en plus importante dans la gestion des territoires 
                   communaux. Dorénavant, les projets d'aménagement sur les communes 
                   qui pourraient servir de référence en la matière 
                   se font dans un souci de cohésion et 
                   de coordination de l'ensemble des services concernés. "]
      , p [] [text "Évolution importante enfin dans le domaine de la 
                   communication, peu connu du grand public en dehors 
                   du panneau d'entrée de commune, le concours avait 
                   besoin de réels outils de promotion. A tous 
                   les niveaux du concours, une communication efficace se 
                   met en place sur les différents territoires (communes, 
                   départements, régions, état). "]
      , p [] [text "Ces évolutions répondaient réellement à un besoin de 
                   changement de la société. L'engouement pour la nature 
                   et l'environnement place la démarche d'aménagement des espaces 
                   verts et tout ce qui s'y rapporte dans 
                   un contexte de développement durable. "]

      , h4 [] [text "Le concours en chiffre"]
      , p  [] [text "Le concours des Villes et Villages Fleuris concerne 
                     près d'une commune française sur trois. "]
      , p  [] [text "En 2008, près de 12 000 communes y 
                     ont participé, 60% d'entre elles étant peuplées de 
                     moins de 1000 habitants. "]
      , p  [] [text "3 468 communes ont été labellisées et peuvent 
                     apposer à leur entrée le panneau Ville Fleurie 
                     ou Village Fleuri. 205 sont classées 4 Fleurs. "]
      ]