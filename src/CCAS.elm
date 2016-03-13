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
      [ h2 [] [text "Centre Communal d'Action Sociale"]
      , p []
          [ text "Le CCAS organise chaque année des manifestations
                  pour petits et grands (Noël des enfants et "
          , a [href "/Annee2016.html"]
              [text "repas du CCAS"]
          , text ")."
          ]
      , p []
          [ text "En dehors de ces actions collectives, le CCAS 
                  souhaite être une "
          , b [] [text "réponse de proximité"]
          , text " aux difficultés 
                 que vous pouvez rencontrer dans votre vie quotidienne:"
          ]
      , ul []
           [ li [] [b [] [text "Aide d’urgence"]
                         , text " grâce à la régie d’avance
                                  (denrées alimentaires, soins médicaux,
                                   transport, fourniture d’énergie…) "
                         ]
           , li [] [b [] [text "Secours"], text " ponctuels "]
           , li [] [ text "Don de "
                   , b [] [text "bois"]
                   , text " de chauffage"]
           , li [] [ text "Aide pour les "
                   , b [] [text "démarches administratives"]
                   , text " (constitution de 
                            dossiers, mise en relation avec les services sociaux…) "]
           , li [] [text "Aide à l’accès à la "
                   , b [] [text "téléassistance"]
                   , text " pour 
                           les personnes seules, financée en partie par le 
                           CCAS"
                   ]
           ]
      , p [style [("text-align","center"),("fonts-size","2em")]]
          [b [] [text "N’hésitez pas à nous contacter! "]]
      , p [style [("text-align","center")]]
          [text "Les membres du CCAS se sont engagés à 
                la confidentialité. "]
      
      , table [id "tableCCAS"]
              [ th [colspan 5]
                   [text "LES MEMBRES DU CENTRE COMMUNAL D’ACTION SOCIALE (CCAS)"]
              , tr []
                   [ td [] [text "Sébastien"]
                   , td [] [text "GOUTTEBEL"]
                   , td [] [text "président"]
                   , td [] [text "Chautignat"]
                   , td [] [text "06 45 28 85 89"]
                   ]
              , tr []
                   [ td [] [text "Sylvie"]
                   , td [] [text "GILLARD"]
                   , td [] [text "vice-présidente"]
                   , td [] [text "Allée de la Plage"]
                   , td [] [text "06 60 97 80 58"]
                   ]
              , tr []
                   [ td [] [text "Floriane"]
                   , td [] [text "CHAZEY"]
                   , td [] [text "secrétaire"]
                   , td [] [text "Rue George Sand"]
                   , td [] [text "06 79 79 20 71"]
                   ]
              , tr []
                   [ td [] [text "Catherine"]
                   , td [] [text "MAURY"]
                   , td [] [text "trésorière"]
                   , td [] [text "Rue de la Vieille Tour"]
                   , td [] [text "06 45 18 45 35"]
                   ]
              , tr []
                   [ td [] [text "Joséphine"]
                   , td [] [text "LANARO"]
                   , td [] [text "régisseur"]
                   , td [] [text "Allée de la Plage"]
                   , td [] [text "06 33 65 09 04"]
                   ]
              , tr []
                   [ td [] [text "Monique"]
                   , td [] [text "PICOT"]
                   , td [] [text "régisseur suppléante"]
                   , td [] [text "La Chassagne"]
                   , td [] [text "04 73 88 65 79"]
                   ]
              , tr []
                   [ td [] [text "Véronique"]
                   , td [] [text "DEBOUT"]
                   , td [] [text "conseillère municipale"]
                   , td [] [text "Rue de Besse"]
                   , td [] [text "06 28 06 81 77"]
                   ]
              , tr []
                   [ td [] [text "Christelle"]
                   , td [] [text "ROUX"]
                   , td [] [text "conseillère municipale"]
                   , td [] [text "Route de Jassat"]
                   , td [] [text "06 47 01 43 62"]
                   ]
              , tr []
                   [ td [] [text "Paulette"]
                   , td [] [text "BENATEK"]
                   , td [] [text "membre nommé"]
                   , td [] [text "Chautignat"]
                   , td [] [text "04 73 88 63 90"]
                   ]
              , tr []
                   [ td [] [text "Olivier"]
                   , td [] [text "DHAINAUT"]
                   , td [] [text "membre nommé"]
                   , td [] [text "Groire"]
                   , td [] [text "06 99 40 17 08"]
                   ]
              , tr []
                   [ td [] [text "Suzanne"]
                   , td [] [text "PLANEIX"]
                   , td [] [text "membre nommé"]
                   , td [] [text "Rue de la Vieille Tour"]
                   , td [] [text "04 73 78 65 08"]
                   ]
              ]
      ]


      --, p  [] [text "Président: Sébastien GOUTTEBEL"]
      --, p  [] [text "Vice-présidente: Sylvie GILLARD"]
      --, p  [] [text "Membres: Véronique DEBOUT, Joséphine LANARO, Cathy MAURY"]
      --, p  [] [text "Régie : Joséphine LANARO"]
      --, p  [] [text "Membres non élus désignés par le maire parmi les Murolais:"]
      --, p  [] [text "Paulette Benatek, Floriane Chazet-Fillon, Olivier Dhainaut, Monique Picot et Suzanne Planeix"]
      --, p  [] [text "+ cinq membres non élus à désigner par le maire parmi les Murolais."]
      --, h4 [] [text "Mutuelle municipale"]
      --, p  [] [text "Votre avis compte !"]
      --, p  [] [text "Lors des élections, vous avez soutenu l’élaboration d’un 
      --               projet concret pour améliorer votre pouvoir d’achat :"]
      --, p  [] [text "la création d’une complémentaire santé communale avec un 
      --               tarif unique et accessible à tous. Une complémentaire 
      --               santé, rappelons-le, sert à couvrir partiellement ou en 
      --               totalité les frais médicaux non remboursés par votre 
      --               assurance maladie. Nous sollicitons aujourd’hui un peu de 
      --               votre temps pour répondre à quelques questions qui 
      --               permettront de créer une offre adaptée à vos 
      --               besoins. Grâce au questionnaire ci-dessous les tarifs des 
      --               différentes mutuelles seront mis en concurrence. "]
      --, p  [] [text "La commune lance une consultation pour proposer une 
      --               complémentaire santé à des tarifs négociés à ses 
      --               habitants. Proposé aux murolais de se regrouper pour 
      --               négocier une complémentaire santé à des tarifs préférentiels"]
      --, p  [] [text "Vous recevrez dans le bulletin municipal un questionnaire 
      --               à remplir et à retourner pour cerner les 
      --               besoins et les personnes concernées par ce dispositif, 
      --               vous pouvez également répondre en ligne au questionnaire 
      --               en suivant le lien ci-dessous.. "]
      --, p [] [text "Une fois les réponses des murolais compilées par 
      --              la mairie, les élus passeront ensuite à la 
      --              phase de négociation avec les organismes de santé. 
      --              \" Plus nous serons nombreux, plus les tarifs 
      --              seront intéressants.\""]
      
      --, h5 [] [text "Questionnaire Mutuelle municipale"]
      --, link "Remplir en ligne" "https://docs.google.com/forms/d/179U2zTrhm6usamB724BMlI197oXq58-TS-3sIi933wM/viewform?usp=send_form"

      --]
 
