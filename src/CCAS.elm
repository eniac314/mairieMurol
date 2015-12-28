module CCAS where

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

type alias Category =
  { title   : String
  , entries : List Entry
  }

type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Mairie","CCAS"]
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
  div [ class "subContainerData noSubmenu", id "ccas"]
      [ h2 [] [text "Centre Communal d'Action Social"]
      , p  [] [text "Président: Sébastien GOUTTEBEL"]
      , p  [] [text "Vice-présidente: Sylvie GILLARD"]
      , p  [] [text "Membres: Véronique DEBOUT, Joséphine LANARO, Cathy MAURY"]
      , p  [] [text "Régie : Joséphine LANARO"]
      , p  [] [text "+ cinq membres non élus à désigner par le maire parmi les Murolais."]
      , h4 [] [text "Mutuelle municipale"]
      , p  [] [text "Votre avis compte !"]
      , p  [] [text "Lors des élections, vous avez soutenu l’élaboration d’un 
                     projet concret pour améliorer votre pouvoir d’achat :"]
      , p  [] [text "la création d’une complémentaire santé communale avec un 
                     tarif unique et accessible à tous. Une complémentaire 
                     santé, rappelons-le, sert à couvrir partiellement ou en 
                     totalité les frais médicaux non remboursés par votre 
                     assurance maladie. Nous sollicitons aujourd’hui un peu de 
                     votre temps pour répondre à quelques questions qui 
                     permettront de créer une offre adaptée à vos 
                     besoins. Grâce au questionnaire ci-dessous les tarifs des 
                     différentes mutuelles seront mis en concurrence. "]
      , p  [] [text "La commune lance une consultation pour proposer une 
                     complémentaire santé à des tarifs négociés à ses 
                     habitants. Proposé aux murolais de se regrouper pour 
                     négocier une complémentaire santé à des tarifs préférentiels"]
      , p  [] [text "Vous recevrez dans le bulletin municipal un questionnaire 
                     à remplir et à retourner pour cerner les 
                     besoins et les personnes concernées par ce dispositif, 
                     vous pouvez également répondre en ligne au questionnaire 
                     en suivant le lien ci-dessous.. "]
      , p [] [text "Une fois les réponses des murolais compilées par 
                    la mairie, les élus passeront ensuite à la 
                    phase de négociation avec les organismes de santé. 
                    \" Plus nous serons nombreux, plus les tarifs 
                    seront intéressants.\""]
      
      , h5 [] [text "Questionnaire Mutuelle municipale"]
      , link "Remplir en ligne" "https://docs.google.com/forms/d/179U2zTrhm6usamB724BMlI197oXq58-TS-3sIi933wM/viewform?usp=send_form"

      ]
 
