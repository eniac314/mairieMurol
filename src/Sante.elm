module Sante where

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


type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Vie Locale", "Santé"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]



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
  div [ class "subContainerData noSubmenu", id "sante"]
      [ h2 [] [text "Santé"]
      , h3 [] [text "La Maison de Santé"]
      , p  [] [text "Nos professionnels de santé vous accueillent à la maison de santé: "]
      , p  [] [text "Rue Maupassant- 63790 MUROL"]
      , img [src "/images/maisonSante.jpg"] []
      , div [ class "praticiens"]
            [ h4 [] [ text "Cabinet médical"]
            , p  [] [ text "Tél : 04 73 88 61 91"]
            , br [] []
            , p  [class "pratiName"] [text "Dr Florence BARRIERE"]
            , p  [] [ text "les lundi, mercredi, vendredi sur rendez-vous, samedi sans RDV."]
            , br [] []
            , p  [class "pratiName"] [text "Dr Cécile MERITE"]
            , p [] [text "les mardi et jeudi sur rendez-vous, samedi sans RDV."]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "Cabinet dentaire"]
            , p  [] [text "Tél :  04 73 88 27 96"]
            , p  [class "pratiName"] [text "Dr JOLIVET Maud"]
            , p  [] [text "Lundi - Mercredi - Vendredi"]
            , p  [] [text "de 9h00 à 12h00 / 14h00 à 19h00"]
            , p  [] [text "3 samedis par mois de 9h00 à 12h00"]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "Cabinet Infirmiers"]
            , p  [] [text "Tél : 04 73 88 68 40"]
            , p  [class "pratiName"] [text "Mme Chauvière Marie-pierre"]
            , p  [class "pratiName"] [text "Mr Morbin Guillaume"]
            , p  [class "pratiName"] [text "Mme Soulier Sandrine"]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "Kinésithérapeute "]
            , p [] [text "Tél : 04 73 88 63 46"]
            , p  [class "pratiName"] [text "Mr Monnet Sébastien"]
            , p  [class "pratiName"] [text "Mme MAYER Céline"]
            , p  [class "pratiName"] [text "Mr GARCIA Mathias"]
            ]
      , h3 [] [text "Pharmacie"]
      , div [class "praticiens"]
            [ h4 [] [text "Pharmacie BRASSIER"]
            , p [] [text "Tél : 04 73 88 60 42"]
            , p [] [text "Rue Estaing - 63790 MUROL"]
            ]
      ]