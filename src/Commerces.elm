module Commerces where

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
                       link)

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }

type alias Commerce =
   { name  : String
   , descr : List String
   , addr  : String
   , tel   : String
   , fax   : String
   , mail  : String
   , site  : String
   }

type alias CommerceMap = Dict String (List Commerce)

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Vie économique", "Commerces"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

renderCommerceMap : CommerceMap -> Html
renderCommerceMap am = 
  let toDiv k v acc =
        (div [class "businesses"]
            ( [ h5 [] [text k]] ++
                List.map renderCommerce v)) :: acc
      toDivs = Dict.foldr toDiv [] am
  in div [] toDivs     
  


renderCommerce : Commerce -> Html
renderCommerce { name, descr, addr, tel, fax, mail, site} = 
  let name'  = maybeElem name (\s -> p [] [text s])
      descr' = List.map (\s -> p [] [text s]) descr
      addr'  = maybeElem addr (\s -> p [] [text s])
      tel'   = maybeElem
                tel (\s -> p [] [text ("Tel. " ++ s)])
      fax'   = maybeElem
                fax (\s -> p [] [text ("Fax : " ++ s)])
      mail'  = maybeElem
                mail (\s -> p [] [text "e.mail: ", a [href s] [text s]])

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
  div [ class "subContainerData noSubmenu", id "commerces"]
      [ h2 [] [text "Commerce"]
      , h5 [] [text "Ouvert toute l'année"]
      , renderCommerceMap comMapYearLong
      , h5 [] [text "Ouverture Saisonière"]
      , renderCommerceMap comMapSummer
      ]

--Data 
defCom = Commerce "" [] "" "" "" "" ""

comMapYearLong = fromList
  [("Alimentation générale"
   , [{ defCom |
        name   = "Petit Casino"
      , addr   = "rue Pierre Céleirol - 63790 MUROL"
      , tel    = "04 7380 1364"
      }
     ,
      { defCom |
        name   = "SPAR"
      , addr   = "Rue de Besse - 63790 MUROL"
      , tel    = "04 73 88 60 45 "
      , fax    = "04 73 88 66 60"
      }
    ,
     { defCom |
       name   = "Vival"
     , addr   = "Rue Chabrol - 63790 MUROL"
     , tel    = "04 7388 6156" 
     }]
   )
  ,("Assurances"
   , [{ defCom |
        name   = "AXA assurances Verdier"
      , addr   = "Rue George Sand"
      , tel    = "04 7388 6877"
      , fax    = "04 73 88 63 79"  
      }]
   )
  ,("Banques"
   , [{ defCom |
        name   = "La Poste"
      , addr   = "La Poste"
      , tel    = "04 7388 6149"  
      }]
   )
  ,("Boucherie"
   , [{ defCom |
        addr   = "Rue George Sand 63790 MUROL"
      , tel    = "04 7388 6905"  
      }]
   )
  ,("Boulangerie"
   , [{ defCom |
        addr   = "Rue Chabrol - 63790 MUROL"
      , tel    = "04 7388 6024" 
      }]
   )
  ,("Café"
   , [{ defCom |
        name   = "Café de la côte"
      , addr   = "Rue Chabrol - 63790 MUROL"
      , tel    = "06 7941 0811" 
      }]
   )
  ,("Coiffure"
   , [{ defCom |
        name   = "Beal Patricia"
      , addr   = "Rue Estaing - 63790 MUROL"
      , tel    = "04 7388 6059"  
      }]
   )
  ,("Garage"
   , [{ defCom |
        name   = "Garage Pons"
      , addr   = "Le Marais - 63790 MUROL"
      , tel    = "04 7388 6022"
      , fax    =  "04 73 88 61 33"  
      }
      ,
      { defCom |
        name   = "Murol Moto Sport"
      , descr  = ["Vente, réparations, location parking moto sécurisé et hors gel"]
      , addr   = "route de Besse - 63790 MUROL"
      , tel    = "06 78 08 35 74"
      , fax    = "04 76 88 66 60"
      , mail   = "cattarellisacha@orange.fr"
      , site   = "http://murolmotosport.wifeo.com"   
      }]
   )
  ,("Laverie automatique"
   , [{ defCom |
        name   = "Laverie des Aloés"
      , addr   = "Rue Chabrol - 63790 MUROL"
      , descr  = [ "Ouvert 7 jours / 7 – toute l’année de 8h à 22h"
                 , "Lave-linge: 6 kg / 4,50€ – 16kg / 10,00€"
                 , "Sèche-linge : 1,00€ - Distributeur de lessive"]
      , tel    = "06 52 43 52 52"  
      }
      ,
      { defCom |
        name   = "Blanchisserie et vente de linge de maison"
      , addr   = "Rue Chabrol - 63790 MUROL"
      , tel    = "06 52 43 52 52"
      , mail   = "lavaloes@gmail.com"
      , descr  = ["Ouvert toute l’année"
                 ,"Lundi et jeudi de 14h00 à 19h30 (juillet/août 22h00)"
                 ,"Mercredi de 09h00 à 13h00"
                 ,"Vendredi et samedi de 9h30 à 12h30 / 14h00 à 19h30"
                 ,"Dimanche de 9h30 à 12h30"]   
      }]
   )
  ,("Pharmacie"
   , [{ defCom |
        name   = "Pharmacie Brassier"
      , addr   = "Rue Estaing - 63790 MUROL"
      , tel    = "04 7388 6042" 
      }]
   )
  ,("Produit du terroir"
   , [{ defCom |
        name   = "Les Caves du château"
      , addr   = "Place du pont - 63790 MUROL"
      , tel    = "04 7388 6334"
      }
     ,{ defCom |
        name   = "Saveurs d'antan"
      , addr   = "Le Marais - 63790 MUROL"
      , tel    = "04 7388 6923"  
      }]
   )]
  
comMapSummer = fromList
   [("Art de la maison - cadeaux - souvenirs"
    , [{ defCom |
         name   = "Le grenier du château"
       , addr   = "rue Georges Sand - 63790 MUROL"
       , tel    = "04 7388 9528"
       , mail   = "le-grenier-du-chateau@sfr.fr"
       , descr  = ["Ouvert du 1 avril au 30 septembre de 10h00 à 12h30 / 14h30 à 19h30"] 
      }]
    )
   ,
   ("Artisanat d'Art : Cuir"
    , [{ defCom |
         name   = "Cuir Cath"
       , addr   = "Rue de Chabrol - 63790 MUROL"
       , tel    = "06 1189 1452"
       , mail   = "cuircath63@orange.fr"
       , descr  = ["Ouvert du 1 juillet au 31 août, tout les jours, sauf le lundi et les mercredis matin de mai et juin"] 
      }]
    )
   ,
   ("Produit du terroir"
    , [{ defCom |
         name   = "Lou Cava'yo"
       , addr   = "Rue Georges Sand - 63790 MUROL"
       , tel    = "06 3144 1980"
       , descr  = ["Ouvert du 1/06 au 30/09 de 9h00 à 21h00"]
      }]
    )
   ,
    ("Vêtements"
   , [{ defCom |
        name   = "Altitude cottayshop"
      , addr   = "rue Georges Sand - 63790 MUROL"
      , tel    = ""
      , descr  = ["Ouvert du 1 juillet au 30 septembre de 10h00 à 13h00 et de 15h00 à 20h00"
                 , "Chaussures de randonnée - vêtements divers"]
      }
     ,
      { defCom |
        name   = "Toutiveti"
      , addr   = "Route de Besse - parking supermarché SPAR - 63790 MUROL"
      , tel    = "06 7666 9747"
      , mail   = "toutiveti@hotmail.fr"
      , descr  = [ "Ouvert du 15 avril au 15 septembre de 09h30 à 12h30 et de 14h30 à 19h00.",
                   "Vêtements/chaussures - hommes/femmes/enfants "]
      }]
   )]