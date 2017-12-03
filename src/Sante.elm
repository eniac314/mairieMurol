module Sante where

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


type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu ["Vie locale", "Santé"]
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
      , h3 [] [text "MAISON DE SANTE PLURIDISCIPLINAIRE"]
      , p  [] [text "Nos professionnels de santé vous accueillent à la maison de santé: "]
      , p  [] [text "Rue Maupassant- 63790 MUROL"]
      , div [class "praticiens"]
            [ h4 [] [ text "Secretariat"]
            , p  [class "pratiName"] [text "Mallory ROIRON"]
            , p  [] [text "04 73 88 28 00"]
            ] 

      , img [src "/images/maisonSante.jpg"] []
      
      , div [ class "praticiens"]
            [ h4 [] [ text "CABINET DE MEDECINE GENERALE"]
            , p  [] [ text "Tél : 04 73 88 61 91"]
            , br [] []
            , p  [class "pratiName"] [text "Dr Florence BARRIERE"]
            --, p  [] [ text "les lundi, mercredi, vendredi sur rendez-vous, samedi sans RDV."]
            , br [] []
            , p  [class "pratiName"] [text "Dr Cécile MERITE"]
            --, p [] [text "les mardi et jeudi sur rendez-vous, samedi sans RDV."]
            , p  [class "pratiName"] [text "Dr Claire-Marine HENRY"]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "CABINET DE CHIRURGIE DENTAIRE"]
            , p  [] [text "Tél :  04 73 88 27 96"]
            , p  [class "pratiName"] [text "Dr Maud JOLIVET"]
            --, p  [] [text "Lundi - Mercredi - Vendredi"]
            --, p  [] [text "de 9h00 à 12h00 / 14h00 à 19h00"]
            --, p  [] [text "3 samedis par mois de 9h00 à 12h00"]
            --, p  [class "pratiName"] [text "Dr Elise COLAS"]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "CABINET DE SOINS INFIRMIERS"]
            , p  [] [text "Tél : 04 73 88 68 40"]
            , p  [class "pratiName"] [text "Mme Marie-Pierre CHAUVIÈRE"]
            , p  [class "pratiName"] [text "Mr Guillaume MORBIN"]
            , p  [class "pratiName"] [text "Sandrine SOULIER"]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "CABINET DE KINESITHERAPIE"]
            , p [] [text "Tél : 04 73 88 63 46"]
            , p  [class "pratiName"] [text "Sébastien MONNET"]
            , p  [class "pratiName"] [text "Céline MAYER"]
            , p  [class "pratiName"] [text "Mathias GARCIA"]
            , p  [class "pratiName"] [text "Aurélie MAIZIERES"]
            ]
      , div [ class "praticiens"]
            [
            -- h4 [] [text "CABINET MÉDICAL POLYVALENT"]
            --, p [] [text "Tél : 04 73 55 30 59 "]
            --, p [] [text "Permanences régulières"]
              h4 [] [text "DIÉTÉTICIENNE "]
            , p  [class "pratiName"] [text "Marion MONGHAL"]
            ]
      , div [ class "praticiens"]
            [ h4 [] [text "CABINET DE PEDICURIE PODOLOGIE"]
            , p [] [text "Tél : 06 78 31 48 21"]
            , p  [class "pratiName"] [text "Michel DESPALLE"]
            ]
      , h3 [] [text "Pharmacie"]
      , div [class "praticiens"]
            [ h4 [] [text "Pharmacie BRASSIER"]
            , p [] [text "Tél : 04 73 88 60 42"]
            , p [] [text "Rue Estaing - 63790 MUROL"]
            ]
      ]