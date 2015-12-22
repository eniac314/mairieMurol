module GestionDesRisques where

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
subMenu = []

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

initialContent =
  div [ class "subContainerData", id "gestionDesRisques"]
      [ link "Télécharger le document d'information communal sur les risques majeurs \"DICRIM\"" "http://www.murol.fr/Base_documentaire/Dicrim%20murol%20v2%20mars%2012.pdf"
      , br [] []
      , link "Télécharger la brochure prise en compte du risque sismique en Auvergne" "http://www.murol.fr/Base_documentaire/risque_sismique_auvergne_cle582121.pdf"
      , br [] []
      , h4 [] [text "Réévaluation des risques sismiques de la région Auvergne"]
      , p  [] [text "Les séismes font partie des aléas naturels majeurs, 
                     au même titre que les inondations, les mouvements 
                     de terrain, les incendies de forêts, les avalanches 
                     ou le volcanisme. Ils sont susceptibles d’avoir de 
                     graves conséquences sur les vies humaines et d’affecter 
                     très durement le fonctionnement de notre société. "]
      , p  [] [text "La réglementation en vigueur depuis 1991 vise à 
                     prévenir les effets d’un tel événement notamment par 
                     l’obligation de systèmes constructifs résistants. "]
      , p  [] [text "Le plan Séisme engagé par le gouvernement depuis 
                     2005 a consisté à actualiser les connaissances, à 
                     ajuster les mesures de prévention et de protection 
                     et à favoriser la prise de conscience du 
                     risque notamment en réduisant la vulnérabilité propre de 
                     chaque citoyen."]
      , p  [] [text "Il s’est traduit par la publication de deux 
                     décrets et d’un arrêté, le 22 octobre 2010. 
                     Ces textes redéfinissent le zonage sismique du territoire 
                     français et complètent les règles de construction parasismique 
                     applicables aux bâtiments de classe dite à risque 
                     normal, qui comprennent notamment les maisons individuelles. "]
      , p  [] [text "Le nouveau zonage facilitera l’application des nouvelles normes 
                     européennes de construction parasismique basées elles aussi sur 
                     une approche probabiliste."]
      , p  [] [text "La France améliore la prévention du risque sismique 
                     et étend l’application des règles de construction parasismique 
                     à 21 000 communes à compter du 1er 
                     mai 2011. "]

      , h5 [] [text "L’Auvergne, une région sismiquement active"]
      , p  [] [text "Par un contexte sismotectonique particulier (le Massif Central 
                     et son système de failles profondes), la région 
                     Auvergne est considérée comme une région sismiquement active. 
                     Les séismes de grande ampleur y sont rares 
                     ; le dernier en date remonte au moyen 
                     age : 1490 ; il avait fait d’importants 
                     dommages aux édifices de Riom et Clermont-Ferrand, pour 
                     une magnitude de 5.1 sur l’échelle de Richter."]
      , p  [] [text "L’activité sismique est toutefois permanente avec une centaine 
                     de répliques par an (de magnitude inférieure à 
                     3 et donc peu ou pas perceptibles) enregistrées 
                     par le réseau Sismologique localisé à l’Observatoire de 
                     Physique du Globe. "]
      
      , h5 [] [text "En Auvergne, un zonage redéfini, un aléa sismique 
                     réévalué "]
      , p  [] [text "La région Auvergne est aujourd’hui concernée pour la 
                     totalité de ses communes par des zonages de 
                     sismicité très faible, faible ou modérée. Seules les 
                     zones de sismicité faible (845 communes) ou modérée 
                     (390 communes) disposent d’une réglementation spécifique."]

      , figure []
               [img [src "/images/seismes.gif"] []]
      ]

      

-- Data
