module Commissions where

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

--elusMap = fromList
--  [("gou","Sébastien GOUTTEBEL")
--  ,("dum","Roger DUMONTEL")
--  ,("aub","François AUBERTY")
--  ,("bou","Estel BOUCHE")
--  ,("gil","Sylvie GILLARD")
--  ,("cat","Yvan CATTARELLI")
--  ,("com","Gilles COMPAGNON")
--  ,("deb","Véronique DEBOUT")
--  ,("dot","Anne-Marie DOTTE")
--  ,("lai","Angélique LAIR")
--  ,("lan","Joséphine LANARO")
--  ,("mau","Cathy MAURY")
--  ,("per","Séverine PEROL")
--  ,("rou","Christelle ROUX")
--  ]

--type alias Commission =
--  { name    : String
--  , rapport : String
--  , autres  : List String
--  }

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Mairie","Commissions"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

--renderCom : Commission -> Html
--renderCom { name, rapport, autres} =
--  let get' k = 
--        case get k elusMap of
--             Nothing -> k
--             Just v  -> v 
--      autres' = reverse autres
--      (last,firsts) = (head autres', tail autres')
--      firsts'  = List.foldr (\n a -> (get' n ++ ", ") ++ a) "" firsts
--      last'    = "et " ++ (get' last) ++ "." 
--  in
--  div [ class "commission"]
--      [ h5 [] [text name]
--      , p  [] [text ("Rapporteur: " ++ (get' rapport))]
--      , p  [] [text (firsts' ++ last')]
--      ]

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
  div [ class "subContainerData noSubmenu", id "commissions"]
      [ h2 [] [text "Les commissions"]
      , p [] [text "Les commissions ci-dessous sont ouvertes aux personnes intéressées. 
                   Pour participer, contactez la mairie ou inscrivez-vous en 
                   ligne: "]
      , p [] [text "Inscription en ligne aux différentes", link " commissions" "https://docs.google.com/forms/d/1RzrxYsue2UqQn2VBdPK3AamNAUb1IyejhWfENwjynkA/viewform"]

      , h4 [] [text "Commissions publiques"]
      , div [ class "commission"]
            [ h5 [] [text "La commission artisanat et commerce"]
            , p  [] [text "RAPPORTEUR : Sébastien GOUTTEBEL"]
            , p  [] [text "Gilles COMPAGNON et Christelle ROUX"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission embellissement"]
            , p  [] [text "RAPPORTEUR : Estel BOUCHE"]
            , p  [] [text "Sébastien GOUTTEBEL, Roger DUMONTEL, François AUBERTY, Angélique LAIR et Christelle ROUX"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission animation/tourisme/associations"]
            , p  [] [text "RAPPORTEUR : Sébastien GOUTTEBEL"]
            , p  [] [text "Estel BOUCHE, Anne-Marie DOTTE, Angélique LAIR et Catherine MAURY"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission jeunesse et sport "]
            , p  [] [text "RAPPORTEUR : Véronique DEBOUT"]
            , p  [] [text "Sébastien GOUTTEBEL, François AUBERTY, Estel BOUCHE, Sylvie GILLARD,
                           Gilles COMPAGNON, Joséphine LANARO, Séverine PEROL"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission agriculture, environnement, forêt "]
            , p  [] [text "RAPPORTEUR : Angélique LAIR"]
            , p  [] [text "Sébastien GOUTTEBEL, Roger DUMONTEL, Estel BOUCHE, Gilles COMPAGNON, Anne-Marie DOTTE et Séverine PEROL"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission musée/culture/patrimoine "]
            , p  [] [text "RAPPORTEUR : Catherine MAURY"]
            , p  [] [text "Sébastien GOUTTEBEL, François AUBERTY, Sylvie GILLARD, Véronique DEBOUT et Joséphine LANARO"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission petite enfance"]
            , p  [] [text "RAPPORTEUR : Sylvie GILLARD"]
            , p  [] [text "Sébastien GOUTTEBEL, Estel BOUCHE, Joséphine LANARO et Christelle ROUX"]
            ]
      --, p [] [text "Une commission lac et rivières sera créée prochainement 
      --             par le SIVU, structure porteuse du contrat de 
      --             lac. Nous vous communiquerons les modalités d’inscription dès 
      --             que possible."]
      , h4 [] [text "Commissions non ouvertes au public"]

      , p [] [text "Ces commissions sont des groupes de travail qui 
                   permettent de préparer les éléments qui conduiront à 
                   la prise de décisions en conseil municipal, elles 
                   ne sont pas ouvertes au public. "]
      
      , div [ class "commission"]
            [ h5 [] [text "La commission des travaux, des aménagements et de l’urbanisme"]
            , p  [] [text "RAPPORTEUR : Roger DUMONTEL"]
            , p  [] [text "Sébastien GOUTTEBEL, François AUBERTY, Estel BOUCHE, Sylvie GILLARD, Yvan CATTARELLI, Gilles COMPAGNON et Séverine PEROL"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission du château et de l’archéologie"]
            , p  [] [text "RAPPORTEUR : Yvan CATTARELLI"]
            , p  [] [text "Sébastien GOUTTEBEL, Roger DUMONTEL, François AUBERTY, Angélique LAIR, Séverine PEROL et Christelle ROUX"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission d’appel d’offres (commission réglementaire)"]
            , p  [] [text "Sébastien GOUTTEBEL, Roger DUMONTEL, François AUBERTY, Yvan CATTARELLI, Gilles COMPAGNON, Véronique DEBOUT, Séverine PEROL et Angélique LAIR"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "C.C.A.S. (centre communal d’action sociale, structure réglementaire)"]
            , p  [] [text "Sébastien GOUTTEBEL, Sylvie GILLARD, Véronique DEBOUT, Joséphine LANARO, Cathy MAURY, Christelle ROUX
                          Floriane CHAZEY, Monique PICOT, Paulette BENATEK, Olivier DHAINAUT et Suzanne PLANEIX"]
            ]
      , div [ class "commission"]
            [ h5 [] [text "La commission communication/information"]
            , p  [] [text "RAPPORTEUR : Sylvie GILLARD"]
            , p  [] [text "Sébastien GOUTTEBEL, Estel BOUCHE, Véronique DEBOUT et Anne-Marie DOTTE"]
            ]
      ]

      

-- Data
--comPublic = 
--  [ Commission 
--      "La commission artisanat et commerce"
--      "gou"
--      ["com","rou"]
--  , Commission 
--      "La commission embellissement"
--      "bou"
--      ["gou","dum","aub","lai","rou"]
--  , Commission 
--      "La commission animation/tourisme/associations"
--      "gou"
--      ["bou","dot","lai","mau"]
--  , Commission 
--      "La commission jeunesse et sport"
--      "deb"
--      ["gou","aub","bou","gil","com","lan","per"]
--  , Commission 
--      "La commission agriculture, environnement, forêt"
--      "lai"
--      ["gou","dum","bou","com","dot","per"]
--  , Commission 
--      "La commission musée/culture/patrimoine"
--      "mau"
--      ["gou","aub","gil","deb","lan"]
--  , Commission 
--      "La commission petite enfance"
--      "gil"
--      ["gou","bou","lan","rou"]
--  ]

--comPrivee = 
--  [ Commission
--     "La commission des travaux, des aménagements et de l’urbanisme"
--     "dum"
--     ["gou","aub","bou","gil","cat","com","per"]
--  , Commission
--     "La commission du château et de l’archéologie"
--     "cat"
--     ["gou","dum","aub","lai","per","rou"]
--  , Commission
--     "La commission d’appel d’offres (commission réglementaire)"
--     "gou"
--     ["dum","aub","cat","com","deb","per","lai"]
--  , Commission
--     "Le C.C.A.S. (centre communal d’action sociale, structure réglementaire)"
--     "gou"
--     ["gil","deb","lan","mau","rou"," + cinq membres non élus à désigner par le maire parmi les Murolais"]
--  , Commission
--     "La commission communication/information"
--     "gil"
--     ["gou","bou","deb","dot"]
--  ]
