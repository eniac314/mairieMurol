module BulletinsMunicipaux where

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

type alias Bulletin = 
  { cover : String
  , date  : String
  , index : List String
  , addr  : String
  }
type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu
                       ["Documentation", "Bulletins municipaux"]
                       (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

renderBulletin 
  {cover, date, index, addr} = 
    div [class "bulletin"]
        [ figure [ class "cover"]
                 [ figcaption [] [text date] 
                 , img [src ("/images/bulletin/" ++ cover)] []
                 ]
        , ul []
             ((h6 [] [text "Dans ce numéro:"]
               :: List.map (\e -> li [] [text e]) index)
              ++ [link "Téléchargez ici" addr])
        ]

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

initialContent = bulletin

-- Data
bulletin =
  div [class "subContainerData noSubmenu", id "bullPubli"]
      ( (h2 [] [text "Le bulletin municipal"]) ::
        (List.map renderBulletin bulls)
      )

bulls = List.reverse
 [ Bulletin "cover0.png" "Janvier 2009"
            [ "La maison médicale"
            , "La sécurité : Pompiers et Maîtres Nageurs Sauveteurs"
            , "Murol en chiffres: Les employés communaux"
            , "Le château : travail des archéologues"
            , "Les écoles maternelles et élémentaires"
            , "Murol en images"
            , "Le tri des déchets"
            , "L’animation estivale"
            , "L’embellissement"
            , "Les commissions"
            , "Les opérations 2008"
            , "L’intercommunalité"
            , "L’état civil"
            , "Le site internet"
            ] "/baseDocumentaire/bulletin/1janvier2009.pdf"
 , Bulletin "cover1.png" "Janvier 2011"
            [ "Etat civil 2010"
            , "Horaires des services"
            , "Recensement 2011"
            , "Travaux en cours"
            , "Urbanisme"
            , "Budget et fiscalité"
            , "Archéologie"
            , "Ecoles"
            , "SIVOM de la Vallée Verte"
            , "Animation estivale"
            , "Musée"
            , "Ski de fond"
            , "Embellissement"
            , "Lac Chambon"
            , "Création du SIVU"
            , "Employés communaux"
            , "Propreté"
            , "SIVOM de Besse"
            , "Sécurité: pompiers MNS, gendarmerie"
            , "CCAS services sociaux"
            , "Relais bibliothèque"
            , "TNT"
            , "Murol en images"
            , "Associations"
            , "Calendrier des diverses
               manifestations du
               1er semestre 2011"
            ] "/baseDocumentaire/bulletin/2janvier2011.pdf"
 , Bulletin "cover2.png" "Février 2012"
            [ "Etat civil 2011"
            , "Horaires des services"
            , "Urbanisme"
            , "SIVU assainissement"
            , "Travaux et investissements"
            , "Chantier de jeunesse"
            , "Archéologie"
            , "Musée des peintres"
            , "Ecoles"
            , "Sivom de la Vallée Verte"
            , "Maison médicale"
            , "Communauté de Communes du Massif du Sancy"
            , "Animation estivale"
            , "Sécurité : pompiers, gendarmerie et MNS"
            , "CCAS et services sociaux"
            , "SIVOM de Besse"
            , "Exposition: « la mairie de Murol a 100 ans »"
            , "Elections 2012"
            , "Murol en images"
            , "Associations"
            , "Calendrier des
               manifestations du
               1er semestre 2012"
            ] "/baseDocumentaire/bulletin/3fevrier2012.pdf"
 , Bulletin "cover3.png" "Mars 2013"
            [ "Etat civil"
            , "Urbanisme"
            , "Transports"
            , "Services"
            , "Recyclage"
            , "Sports"
            , "Parcours sportif"
            , "Activités jeunesse"
            , "Eléments budgétaires"
            , "Travaux"
            , "Projets en cours"
            , "SIVU"
            , "Personnel"
            , "Embellissement"
            , "Archéologie"
            , "Musée"
            , "Pompiers"
            , "Plage"
            , "DICRIM cahier détachable"
            , "Murol en images"
            , "Station de tourisme"
            , "ONF"
            , "Animation"
            , "Ecoles"
            , "CCAS"
            , "SIVOM de Besse"
            , "Services sociaux"
            , "Associations"
            , "Calendrier"
            ] "/baseDocumentaire/bulletin/4mars2013.pdf"
  , Bulletin "cover4.png" "Janvier 2014"
             [ "Etat civil"
             , "Elections"
             , "Services"
             , "Chiens et chats"
             , "Personnel"
             , "Eléments budgétaires"
             , "Rue George Sand"
             , "Circulation bourg"
             , "Travaux"
             , "Maison médicale"
             , "Sécurité / Pompiers"
             , "Urbanisme"
             , "Agriculture - Forêts"
             , "Embellissement"
             , "Musée des peintres"
             , "Tourisme"
             , "Murol en images" 
             , "Station de tourisme"
             , "Archéologie"
             , "Ecoles"
             , "Réforme des rythmes scolaires"
             , "Jeunesse et sports"
             , "Lac Chambon"
             , "CCAS Social"
             , "Atelier couture"
             , "Balades du journal"
             , "Informatique et sites"
             , "Associations"
             , "Calendrier"
             ] "/baseDocumentaire/bulletin/5janvier2014.pdf"
 , Bulletin "cover5.png" "Mars 2015"
            [ "Equipe municipale"
            , "Intercommunalité"
            , "Réforme territoriale"
            , "Elections régionales"
            , "Etat civil"
            , "Conseil des jeunes"
            , "Services"
            , "Ordures ménagères"
            , "ADIL (énergie, habitat)"
            , "Personnel"
            , "Chantier de jeunesse"
            , "Travaux 2014"
            , "Maison de santé"
            , "Pompiers"
            , "Eclairage public"
            , "Tourisme"
            , "Festival d'art"
            , "Embellissement"
            , "Archéologie"
            , "Mutuelle"
            , "CCAS"
            , "Ecoles"
            , "SIVOM de la Vallée Verte"
            , "Activités jeunesse"
            , "Eléments budgétaires"
            , "Accessibilité"
            , "Abords du chateau"
            , "Musée des peintres"
            , "Lac Chambon"
            , "Autres projets en cours"
            , "Murol en images"
            , "Associations"
            , "Calendrier"
            ] "/baseDocumentaire/bulletin/26mars2015.pdf"
 , Bulletin "cover6.jpg" "Mars 2016"
            [ "Conseil régional"
            , "Communauté de communes"
            , "Sapeurs pompiers"
            , "SIVOM de besse"
            , "CCAS"
            , "Organicité ®"
            , "Tri des déchets "
            , "Travaux realisés"
            , "Embellissement et fleurissement"
            , "Château et archeologie"
            , "Prélong"
            , "Congres national des maires ruraux"
            , "Murol en images"
            , "Plan local d’urbanisme"
            , "Pavillon bleu"
            , "Ecoles"
            , "SIVOM de la vallée verte"
            , "Activités jeunesse"
            , "Animation estivale"
            , "Grandes manifestations"
            , "Associations"
            , "Musée des peintres"
            , "Investissements"
            , "Etat civil"
            , "Services"
            , "Site municipal"
            , "Maison de sante"
            , "Calendrier"
            ] "/baseDocumentaire/bulletin/mars2016.pdf"
 , Bulletin "cover7.jpg" "Mars 2017"
            [ "La communauté de communes du Sancy"
            , "Le Pôle Lecture Publique"
            , "La charte de développement durable"
            , "Les actions du SIVU"
            , "Les sapeurs-pompiers volontaires"
            , "Les surveillants de baignade"
            , "L'état civil"
            , "Le SIVOM de Besse"
            , "Les actions du CCAS"
            , "Les écoles"
            , "Le SIVOM de la vallée verte"
            , "Salage et déneigement"
            , "Les travaux de l'équipe technique"
            , "Le château et la DSP"
            , "Les travaux de la plage et le pavillon bleu"
            , "Gros travaux et investissements"
            , "Embellissement et fleurissement"
            , "La journée des Murolais et le compostage"
            , "Le tri des déchets"
            , "Les animations"
            , "Le musée"
            , "L'archéologie"
            , "Les associations"
            , "SOS Animaux"
            , "Les éléctions 2017"
            , "Le site internet"
            , "L'annuaire de la maison de santé"
            , "Les services"
            , "Le calendrier"
            ] "/baseDocumentaire/bulletin/mars2017.pdf"
 , Bulletin "cover8.jpg" "Mars 2018"
            [ "Etat civil 2017"
            , "Urbanisme"
            , "Personnel communal"
            , "Sapeurs pompiers"
            , "Eléments budgétaires"
            , "Locations communales"
            , "Travaux équipe technique"
            , "Circulation stationnement"
            , "Travaux des entreprises"
            , "Investissements 2017"
            , "Archéologie"
            , "Château"
            , "Musée des peintres"
            , "Article IGN magazine"
            , "Murol en images"
            , "Animation estivale"
            , "Grandes manifestations"
            , "Communauté de communes du massif du Sancy"
            , "SIVU Couze Chambon"
            , "Pavillon Bleu"
            , "Environnement"
            , "Ecoles"
            , "SIVOM vallée verte"
            , "CCAS"
            , "Attention aux arnaques !"
            , "CLIC et SIVOM de Besse"
            , "Associations"
            , "Services"
            , "Maison de santé"
            , "Calendrier"
            ] "/baseDocumentaire/bulletin/mars2018.pdf"
 ]

