module Entreprises where

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
                       link,
                       split3')

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

type alias Entreprise =
   { name  : String
   , descr : List String
   , addr  : String
   , tel   : String
   , fax   : String
   , mail  : String
   , site  : String
   }

type alias EntrepriseMap = Dict String (List Entreprise)

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Vie économique","Entreprises"] (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

--renderEntrepriseMap : EntrepriseMap -> Html
--renderEntrepriseMap am = 
--  let toDiv k v acc =
--        (div [class "businesses"]
--            ( [ h5 [] [text k]] ++
--                List.map renderEntreprise v)) :: acc
--      toDivs = Dict.foldr toDiv [] am
--  in div [] toDivs     
  
renderEntrepriseMap : EntrepriseMap -> Html
renderEntrepriseMap am = 
  let toDiv k v acc =
        (div [class "businesses", style [("max-width","95%")]]
            ( [ h5 [] [text k]] ++
                List.map renderEntreprise v)) :: acc
      toDivs = Dict.foldr toDiv [] am

      col ds = div [class "column", style [("max-width","30%")]] ds

  in div [] (List.map col (split3' toDivs)) 

renderEntreprise : Entreprise -> Html
renderEntreprise { name, descr, addr, tel, fax, mail, site} = 
  let name'  = maybeElem name (\s -> p [] [text s])
      descr' = List.map (\s -> p [] [text s]) descr
      addr'  = maybeElem addr (\s -> p [] [text s])
      tel'   = maybeElem
                tel (\s -> p [] [text ("Tel. " ++ s)])
      fax'   = maybeElem
                fax (\s -> p [] [text ("Fax : " ++ s)])
      mail'  = maybeElem
                mail (\s -> p [] [text "e.mail: ", a [href ("mailto:"++s)] [text s]])

      site'  = maybeElem
                site (\s -> p [] [text "site: ", a [href s] [text s]])
  in div [] ([name'] ++ descr' ++ [addr', tel', fax', mail', site'])


maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

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
  div [ class "subContainerData noSubmenu", id "entreprises"]
      [ h2 [] [text "Les Entreprises"]
      , renderEntrepriseMap artMap
      , contact
      ]

--Data 
contact = 
   p []
     [ text "Liste non exhaustive, contactez "
     , a [href ("mailto:"++"contactsite.murol@orange.fr")]
         [text "le webmaster"]
     , text " pour toute erreur ou oubli!"
     ]
defArt = Entreprise "" [] "" "" "" "" ""

artMap = fromList
  [("Electricité générale"
   , [{ defArt |
        name   = "Boulhol Cougoul (Sarl)"
      , addr   = "Groire 63790 MUROL"
      , tel    = "04 73 88 67 33"
      }
     ,
      { defArt |
        name   = "Cattarelli Rémi"
      , addr   = "route de Besse - 63790 MUROL"
      , tel    = "06 86 18 16 54"
      , mail   = "remi.cattarelli@orange.fr"
      , site   = "http://electymurol.wifeo.com"
      }
    ,
     { defArt |
       name   = "Sancy Electricité"
     , addr   = "chemin des sables 63790 MUROL"
     , tel    = "04 73 88 67 16" 
     }]
   )
  ,("Electricité et petits travaux du bâtiment"
   , [{ defArt |
        name   = "Olivier Dhainaut"
      , addr   = "Groire 63790 MUROL"
      , tel    = "04 73 88 66 33 ou 06 99 40 17 08"
      , mail   = "ace.dhainaut@neuf.fr"  
      }]
   )
  ,("Maçonnerie"
   , [{ defArt |
        name   = "Bouche Benoît (SARL)"
      , addr   = "Beaune Le Froid 63790 MUROL"
      , tel    = "04 73 88 80 72"
      }]
   )
  ,("Plomberie"
   , [{ defArt |
        name   = "Bouche Nicolas"
      , addr   = "Rue George Sand 63790 MUROL"
      , tel    = "06 64 10 74 78"
      }]
   )
  --,("Peintre en bâtiment"
  -- , [{ defArt |
  --      name   = "Peuch Gérard"
  --    , addr   = "rue de Groire 63790 MUROL"
  --    , tel    = "04 7388 6033" 
  --    }]
  -- )
  ,("Marché de gros et demi-gros"
   , [{ defArt |
        name   = "Jallet Fruits et légumes"
      , addr   = "route de Besse 63790 MUROL"
      , tel    = "04 73 88 66 82"
      , fax    = "04 73 88 64 88"  
      }]
   )
  ,("Quincaillerie"
   , [{ defArt |
        name   = "Legoueix Père et Fils (SARL)"
      , addr   = "rue du Tartaret 63790 MUROL"
      , tel    = "04 7388 6621"
      , fax    = "04 73 88 80 39"  
      }]
   )
  --,("Reprographie"
  -- , [{ defArt |
  --      name   = "Chazay Yvon"
  --    , descr  = ["création - impression - dépannage informatique"]
  --    , addr   = "rue Georges Sand 63790 Murol"
  --    , tel    = "06 2451 7696"
  --    , mail   = "murol.repro@sfr.fr"  
  --    }]
  -- )
  --,("Taxi"
  -- , [{ defArt |
  --      name   = "Amblard Taxi"
  --    , addr   = "La Chassagne 63790 MUROL"
  --    , tel    = "04 7388 6937 ou 06 7455 1533"  
  --    }
  --   ,
  --    { defArt |
  --      name   = "Miseroux Taxi"
  --    , addr   = "Groire 63790 MUROL"
  --    , tel    = "04 7388 8112"
  --    , site   = "www.taxi-murol.com"  
  --    }]
  -- )
  --,("Boulanger"
  -- , [{ defArt |
  --      name   = "Bigand Michel"
  --    , addr   = "Rue Chabrol - 63790 MUROL"
  --    , tel    = "04 7388 6024" 
  --    }]
  -- )
  --,("Boucherie"
  -- , [{ defArt |
  --      addr   = "Rue Chabrol - 63790 MUROL"
  --    , tel    = "04 7388 6905"  
  --    }]
  -- )
  --,("Coiffure"
  -- , [{ defArt |
  --      name   = "Béal Patricia"
  --    , addr   = "rue Estaing 63790 MUROL"
  --    , tel    = "04 7388 6059"  
  --    }]
  -- )
  --,("Création et travail du cuir"
  -- , [{ defArt |
  --      name   = "Peaux de vaches création"
  --    , addr   = "Rue de Chabrol 63790 MUROL"
  --    , tel    = "047378 1653"
  --    , mail   = "marc.humbert.cuir@orange.fr"
  --    , site   = "http://www.peaux-de-vaches-creation.com"  
  --    }]
  -- ) 
  ]
