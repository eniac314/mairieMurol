module LesSeniors where

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
      [ renderMainMenu ["Vie locale", "Les seniors"]
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
       div [ class "subContainerData noSubmenu", id "lesSeniors"]
           [ h2 [] [text "Les seniors"]
           , content])
  , tiledMenu =
      initAtWithLink locationSearch seniors
  }


-- Data
seniors = 
  [ ("Activités et animations"
    ,"/images/tiles/seniors/info.jpg"
    , [ h5 [] [text "Les ateliers informatiques"]
      , p  [] [text "Chaque jeudi, Marie-Agnès Gaime anime deux ateliers informatiques 
                     pour les membres de l’association les Amis du 
                     Vieux Murol, dans la salle de réunion du 
                     1er étage de la mairie, équipée de 5 
                     postes de travail, mise à disposition gratuitement pour 
                     permettre cette initiation. "]
      , p  [] [text "Horaires : 9H/10H30 et 10H30/12H "]
      , p  [] [text "Renseignements et inscriptions "]
      , p  [] [text "Marie-Agnès Gaime : 04 73 88 65 24"]

      , h5 [] [text "Le repas du CCAS de Murol "]
      , p  [] [text "Chaque année, au mois de janvier, le CCAS 
                     organise une journée conviviale pour les murolais de 
                     65 ans et plus. "]
      , p  [] [text "La journée commence par les vœux du maire 
                     à toute la population. Il retrace les réalisations 
                     et les projets en cours pendant qu’un diaporama 
                     de l’année écoulée est présenté. "]
      , p  [] [text "Ensuite, les personnes de 65 ans et plus 
                     sont conviées à partager un repas festif dans 
                     l’un des restaurants de la commune. Dans l’après-midi, 
                     une animation musicale invite les convives à danser 
                     et à chanter. "]
      
      , h5 [] [text "Les activités de l’association des Amis du Vieux 
                     Murol "]
      , a  [href "/Associations.html?bloc=00"] [text "Les associations culturelles"]
      , h5 [] [text "Les animations du SIVOM de Besse et le 
                     bus des montagnes"]
      , p  [] [text "Ce service propose des activités, déplacements et voyages 
                    à l’ensemble des seniors du territoire. "]
      , text "Au programme pour 2017 : "
      , a [href "baseDocumentaire/animation/animations SIVOM 2017.pdf", target "_blank"]
          [text "voir le programme 2017"]
      , p []
          [ text "pour tout renseignement
                  contactez le "
          , a [ href "/LesSeniors.html?bloc=01"]
              [ text "SIVOM de Besse"]
          ]
      ]
    , ""
    )
  ,
   ("Services du SIVOM de BESSE"
   ,"/images/tiles/seniors/SIVOM.jpg"
   , [ div [ id "SIVOMAddress"]
           [ p [] [text "SIVOM DE BESSE "]
           , p [] [text "14, place du Grand Mèze"]
           , p [] [text "63610 BESSE "]
           , p [] [text "Tél : 04 73 79 52 82"]
           ]
     , p  [] [text "Le SIVOM de Besse est une structure intercommunale 
                   qui offre de multiples services pour améliorer le quotidien 
                   des personnes de plus de 60 ans. "]
     
     , h5 [] [text "Le service d’aide à domicile "]

     , text "Ce service est composé de 20 aides à 
             domicile qui assistent les personnes de plus de 
             60 ans pour la réalisation des tâches de 
             la vie quotidienne: "

     , ul []
          [ li [] [text "Entretien du logement"]
          , li [] [text "Courses et préparation des repas "]
          , li [] [text "Aide aux démarches simples "]
          ]
     , p [] [text "La participation des bénéficiaires est calculée en fonction 
                   des ressources."]

     , h5 [] [text "Le portage des repas "]
     , p  [] [text "Les repas sont livrés à domicile les mardis, 
                   jeudis et vendredis et couvrent les besoins quotidiens 
                   de la personne. "]
     , p  [] [text "Ils comprennent 6 plats accompagnés de pain : 
                   entrée, potage, viande ou poisson, légume ou féculent, 
                   fromage ou yaourt, dessert."]
     , p  [] [text "Possibilité de repas de régimes (sans sel/ diabétique/ 
                    coupé) "]

     , h5 [] [text "Le Service de Soins Infirmiers à Domicile (SSIAD) "]
     , p  [] [text "Les aides-soignantes interviennent à domicile 7 jours sur 
                   7. "]
     , p  [] [text "Le forfait de soins est intégralement pris en 
                   charge par l’ ARS (agence régionale de santé). "]

     , h5 [] [text "La distribution de colis alimentaires"]
     , p  [] [text "Ce service s’adresse aux personnes à faibles 
                   ressources du territoire 
                   sur la base d’un diagnostic effectué par les 
                   assistants sociaux. "]
     , p  [] [text "Pour pouvoir bénéficier de ce service, prenez rendez-vous 
                   avec un(e) assistant(e) social(e) de la circonscription en 
                   appelant le : 04 73 89 48 55. "]

     , h5 [] [text "Les  "
             , a [ href "/LesSeniors.html?bloc=00"
                 , target "_blank"] [text "animations du 3ème âge et le bus 
                    des montagnes"]
             ]
     , p  [] [text "Ce service propose des activités, déplacements et voyages 
                  à l’ensemble des seniors du territoire. "]

     ]
   , ""
   )
  ,
   ("Autres services"
   ,"/images/tiles/seniors/autres.jpg"
   , [ a [href "/CCAS.html"] [text "Le CCAS de Murol"]
     , br [] []
     , a [href "http://www.puydedome.com/MobiPlus-67262.html?1=1"
         , target "_blank"
         ]
         [text "Les chèques transport mobiplus "]
     , h5 [] [text "Les assistants sociaux de la circonscription"]
     , p  [] [text "Les assistants sociaux peuvent vous aider dans vos 
                   démarches administratives ou en cas de difficultés financières. 
                   Ils assurent des permanences à Besse et se 
                   déplacent à domicile."]
     , p [] [text "N’hésitez pas à les contacter pour prendre rendez-vous: "
            , br [] []
            ,text "Circonscription d’action médico-sociale Sancy Val d’Allier au 04 
                  73 89 48 55"]
     , a [href "http://www.pour-les-personnes-agees.gouv.fr "
         , target "_blank"
         ]
         [text "Le portail dédié aux personnes âgées"]
     ]
   , ""
   )
  ]


  