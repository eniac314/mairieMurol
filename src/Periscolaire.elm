module Periscolaire where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initWithLink,view,update,Action)
import StarTable exposing (makeTable, emptyTe, Label(..))
import Murol exposing (mainMenu,
                       renderMainMenu',
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)


-- Model
subMenu : Murol.Submenu
subMenu = { current = "", entries = []}

type alias MainContent = 
  { wrapper : (Html -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Murol.Menu
  , subMenu     : Murol.Submenu
  , mainContent : MainContent
  }  

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }



-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Vie Loale", "Péri et extra-scolaire"]
                        (.mainMenu model)
      , div [ id "subContainer"]
            [ (.wrapper (.mainContent model))
               (TiledMenu.view (Signal.forwardTo address TiledMenuAction) (.tiledMenu (.mainContent model)))
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
            mainContent = 
             { mc | tiledMenu = TiledMenu.update act tm }
          }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }


initialContent =
  { wrapper = 
    (\content ->
       div [ class "subContainerData noSubmenu", id "periscolaire"]
           [ h2 [] [ text "péri et extra-scolaire"]
           , content])
  , tiledMenu =
      initWithLink peri
  }


-- Data
peri =
  [ ("Restaurant scolaire"
    ,""
    , [ link "Fiche d'inscription" ""
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
      ]
    ,"")
  , ("Garderie périscolaire"
    ,""
    , [  p [] [ text "Les Chèques Emploi Service Universel sont dorénavant acceptés pour
                    le paiement de la garderie périscolaire."]
      , link "Fiche d'inscription" ""
      , p [] [ text "ouverte de 7h00 à 9h00 et de 16h30 à 19h00 : 1,20€ de l’heure."]
      , p [] [ link "Charte du savoir-vivre" ""
             , text " en milieu scolaire et périscolaire"]
      , p [] [ link "Règlement intérieur" ""
             , text " du restaurant scolaire et de la garderie"] 
     ]
    ,""
    )
  , ("Temps d'activités périscolaires (TAP)"
    ,""
    ,[]
    ,""
    )
  , ("Centre de loisirs"
    ,""
    , [ p [] [ text "Ouvert pendant les vacances scolaires"]
      , p [] [ text "Le centre de loisirs est ouvert du lundi au vendredi, dans les
                     locaux de l'école maternelle de Murol"]
      , p [] [ text "Inscription en mairie"]
      ]
    ,""
    )
  , ("Transport scolaire"
    ,""
    , [ p [] [ text "Pour le transport scolaire, la participation des familles 
                   a été fixée forfaitairement par le Conseil Général 
                   pour l’année scolaire 2008 / 2009 à 12,80€ 
                   par mois (64€ par mois pour les élèves 
                   non subventionnés)."] 
      ]
    ,""
    )
  , ("Activités jeunesse de la communauté de communes"
    ,""
    ,[]
    ," http://www.cc-massifdusancy.fr/"
    )
  ]
  