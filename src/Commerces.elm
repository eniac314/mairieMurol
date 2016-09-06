module Commerces where

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
                       prettyUrl,
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

type alias Commerce =
   { name  : String
   , descr : List String
   , addr  : String
   , tel   : String
   , fax   : String
   , mail  : String
   , site  : String
   , pjaun : String
   , refOt : Maybe (String,String)
   }

type alias CommerceMap = Dict String (List Commerce)

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu ["Vie économique", "Commerces"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

renderCommerceMap : CommerceMap -> Html
renderCommerceMap am = 
  let toDiv k v acc =
        (div [class "businesses", style [("max-width","95%")]]
            ( [ h5 [] [text k]] ++
                List.map renderCommerce v)) :: acc
      toDivs = Dict.foldr toDiv [] am

      col ds = div [class "column", style [("max-width","30%")]] ds

  in div [] (List.map col (split3' toDivs))     
  


renderCommerce : Commerce -> Html
renderCommerce { name, descr, addr, tel, fax, mail, site, pjaun, refOt} = 
  let name'  = maybeElem name (\s -> p [] [anchor s, text s])
      descr' = List.map (\s -> p [] [text s]) descr
      addr'  = maybeElem addr (\s -> p [] [text s])
      tel'   = maybeElem
                tel (\s -> p [] [text ("Tel. " ++ s)])
      fax'   = maybeElem
                fax (\s -> p [] [text ("Fax : " ++ s)])
      mail'  = maybeElem
                mail (\s -> p [] [text "e.mail: ", a [href ("mailto:"++s)] [text s]])

      site'  = maybeElem
                site (\s -> p [] [text "site: ", a [href s, target "_blank"] [text (prettyUrl s)]])
      pjaun'  = maybeElem
                 pjaun (\s -> p [] [text "Pages Jaunes: ", a [href s] [text s]])
      refOt' = case refOt of
                 Nothing ->  nullTag
                 Just (n,ad) -> p [] [ text ("Référence OT: ")
                                     , a [href ad, target "_blank"]
                                         [text n]
                                     ] 

  in div [] ([name',refOt'] ++ descr' ++ [addr', tel', fax', mail', site', pjaun'])


anchor s = a [name (String.concat (String.words s))] []

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
      [ h2 [] [text "Commerces et services"]
      , h5 [] [text "Ouvert toute l'année"]
      , renderCommerceMap comMapYearLong
      , h5 [] [text "Ouverture Saisonnière"]
      , renderCommerceMap comMapSummer
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

defCom = Commerce "" [] "" "" "" "" "" "" Nothing

comMapYearLong = fromList
  [("Alimentation"
   , [{ defCom |
        name   = "Petit Casino"
      , descr  = ["Alimentation générale"]
      , addr   = "rue Pierre Céleirol - 63790 MUROL"
      , tel    = "04 73 88 80 13"
      }
     ,
      { defCom |
        name   = "Supermarché SPAR"
      , refOt  = Just ("4236","http://www.sancy.com/activites/detail/4236/murol/spar")
      , descr  = ["Alimentation générale", "Service drive et livraison: www.sparmurol.fr"]
      , addr   = "Rue de Besse - 63790 MUROL"
      , tel    = "04 73 88 60 45 "
      , fax    = "04 73 88 66 60"
      }
    ,
     { defCom |
       name   = "Vival"
     , refOt  = Just ("3663","http://www.sancy.com/activites/detail/3663/murol/vival")
     , descr  = ["Alimentation générale"]
     , addr   = "Rue Chabrol - 63790 MUROL"
     , tel    = "04 73 88 61 56" 
     }
    
    ]
   )
  ,("Assurances"
   , [{ defCom |
        name   = "AXA assurances Verdier"
      , addr   = "Rue George Sand 63790 MUROL"
      , tel    = "04 73 88 68 77"
      , fax    = "04 73 88 63 79"  
      }]
   )
  ,("Poste banque distributeur"
   , [{ defCom |
        name   = "La poste la Banque Postale"
      , refOt  = Just ("6246","http://www.sancy.com/activites/detail/6246/murol/la-poste")
      , descr  = ["services postaux et bancaires distributeur de billets"]
      , addr   = "Rue George Sand 63790 MUROL"
      , tel    = "04 73 88 61 49 - National: 36 31"
      , site   = "http://www.laposte.fr"  
      }
      ,
      { defCom |
        name   = "Distributeur SPAR"
      , refOt  = Just ("7331","http://www.sancy.com/activites/detail/7331/murol/distributeur-automatique-de-billets")
      , descr  = ["Distributeur de billets"] 
      , addr   = "Route de Besse 63790 MUROL" 
      }]
   )
  ,("Boucherie"
   , [{ defCom |
        name   = "La Pièce du Boucher"
      , addr   = "Rue George Sand 63790 MUROL"
      , tel    = "04 73 87 77 48"  
      }]
   )
  --,("Boulangerie"
  -- , [{ defCom |
  --      addr   = "Rue Chabrol - 63790 MUROL"
  --    , tel    = "04 7388 6024" 
  --    }]
  -- )
  --,("Café"
  -- , [{ defCom |
  --      name   = "Café de la côte"
  --    , addr   = "Rue Chabrol - 63790 MUROL"
  --    , tel    = "06 7941 0811" 
  --    }]
  -- )
  ,
  ("Art de la maison - cadeaux - souvenirs"
    , [{ defCom |
         name   = "Le grenier du château"
       , refOt  = Just ("7548","http://www.sancy.com/activites/detail/7548/murol/le-grenier-du-chateau")
       , addr   = "Rue Georges Sand - 63790 MUROL"
       , tel    = "04 73 88 95 28"
       , mail   = "le-grenier-du-chateau@sfr.fr"
       , descr  = ["Art de la maison, cadeaux, souvenirs"] 
      }
      ]
  )
  ,("Coiffure"
   , [{ defCom |
        name   = "Beal Patricia"
      , descr  = ["Coiffure mixte"]
      , addr   = "Rue Estaing - 63790 MUROL"
      , tel    = "04 73 88 60 59"  
      }]
   )
  ,("Garage"
   , [{ defCom |
        name   = "Garage de l'Avenir"
      , descr  = ["Réparations toutes marques, carburants"]
      , addr   = "Le Marais - 63790 MUROL"
      , refOt  = Just ("3682","http://www.sancy.com/activites/detail/3682/murol/garage-de-l-avenir")
      --, tel    = "04 7388 6022"
      --, fax    =  "04 73 88 61 33"  
      }
      ,
      { defCom |
        name   = "Murol Moto Sport"
      , descr  = ["Vente réparations toutes marques"]
      , addr   = "route de Besse - 63790 MUROL"
      , tel    = "06 78 08 35 74"
      , fax    = "04 76 88 66 60"
      , mail   = "cattarellisacha@orange.fr"
      --, site   = "http://murolmotosport.wifeo.com"   
      }]
   )
  ,("Laverie"
   , [{ defCom |
        name   = "Laverie des Aloés"
      , addr   = "Rue Chabrol - 63790 MUROL"
      , descr  = [ "Ouvert 7 jours / 7 – toute l’année de 8h à 22h"
                 , "lave-linge 6 et 18 kg/ sèche linge"
                 ]
      , tel    = "06 72 16 78 46"
      , mail   = "laverielesaloes@gmail.com"  
      }]
      --,
      --{ defCom |
      --  name   = "Blanchisserie et vente de linge de maison"
      --, addr   = "Rue Chabrol - 63790 MUROL"
      --, tel    = "06 52 43 52 52"
      --, mail   = "lavaloes@gmail.com"
      --, descr  = ["Ouvert toute l’année"
      --           ,"Lundi et jeudi de 14h00 à 19h30 (juillet/août 22h00)"
      --           ,"Mercredi de 09h00 à 13h00"
      --           ,"Vendredi et samedi de 9h30 à 12h30 / 14h00 à 19h30"
      --           ,"Dimanche de 9h30 à 12h30"]   
      --}]
   )
  ,("Pharmacie"
   , [{ defCom |
        name   = "Pharmacie Brassier"
      , addr   = "Rue Estaing - 63790 MUROL"
      , tel    = "04 73 88 60 42" 
      }]
   )
  ,
   ("Artisanat d'Art, galerie d'art, antiquité"
    , [{ defCom |
         name   = "Atelier ST Christophe"
       , addr   = "Rue George Sand 63790 MUROL"
       , tel    = "04 63 22 68 15"
       , descr  = ["Création de bijoux"] 
      }
      ,
      { defCom |
         name   = "Atelier Hotantik by Fab"
       , addr   = "Rue Chabrol 63790 MUROL"
       , tel    = "06 80 00 11 09"
       , descr  = ["Sculpture, ferronnerie"] 
      }
      ,
      { defCom |
         name   = "Galerie d'Art"
       , addr   = "Rue George Sand 63790 MUROL"
      }
      ]
    )
  ,
   ("Transport"
    , [{ defCom |
         name   = "Amblard Taxi"
       , refOt  = Just ("3922","http://www.sancy.com/activites/detail/3922/murol/taxi-amblard") 
       , addr   = "La Chassagne 63790 MUROL"
       , tel    = "04 73 88 69 37 / 06 74 55 15 33"
       , descr  = ["Taxi, transport malade assis"] 
      }
      ,
      { defCom |
         name   = "Taxi Miseroux"
       , refOt  = Just ("4552","http://www.sancy.com/activites/detail/4552/murol/taxi-miseroux")   
       , addr   = "Groire 63790 MUROL"
       , tel    = "04 73 88 81 12"
       , descr  = ["Taxi, transport malade assis"] 
      }
      ,
      { defCom |
         name   = "Navette publique"
       , refOt  = Just ("6505","http://www.sancy.com/activites/detail/6505/murol/ligne-reguliere-chambon-murol-st-nectaire-clermont")
       , tel    = "04 73 88 62 62 / 04 73 88 60 67"
       , descr  = ["ligne pour Clermont Ferrand"]
      }
      ]
    )
   ,(" Informatique: dépannage, graphiste, créateur"
   , [{ defCom |
        name   = "Volcanographics"
      , descr  = ["Site internet, logo…"] 
      , addr   = "Groire 63790 MUROL"
      , tel    = "04 73 62 11 07 / 06 81 86 69 43"
      , mail   = "contact@volcanographics.com"
      , site   = "http://www.volcanographics.com"
      }
     ,
     { defCom |
        name   = "Yvon CHAZEY"
      , descr  = ["Création, reprographie, dépannage"] 
      , addr   = "Rue George Sand 63790 MUROL"
      , tel    = "06 24 51 76 96"
      , mail   = "murol.repro@sfr.fr"
      }
     ]
   )
   ,
   ("Artisanat d'Art, galerie d'art, antiquité"
    , [{ defCom |
         name   = "Atelier ST Christophe"
       , addr   = "Rue George Sand 63790 MUROL"
       , tel    = "04 63 22 68 15"
       , descr  = ["Création de bijoux"] 
      }
      ,
      { defCom |
         name   = "Atelier Hotantik by Fab"
       , addr   = "Rue Chabrol 63790 MUROL"
       , tel    = "06 80 00 11 09"
       , descr  = ["Sculpture, ferronnerie"] 
      }
      ,
      { defCom |
         name   = "Galerie d'Art"
       , addr   = "Rue George Sand 63790 MUROL"
      }
      ]
    )
   
  ,("Produit du terroir"
   , [{ defCom |
        name   = "Les Caves du château"
      , refOt  = Just ("3673","http://www.sancy.com/activites/detail/3673/murol/les-caves-du-chateau")
      , descr  = ["caviste, fromager, produits du terroir"] 
      , addr   = "Place du pont - 63790 MUROL"
      , tel    = "04 73 88 63 34"
      }
     ,
     { defCom |
        name   = "la Musardiere"
      , descr  = ["Produits du terroir, souvenirs"] 
      , addr   = "Rue d'Estaing 63790 MUROL"
      , tel    = "04 73 88 69 09"
      }
     ]
   )]
  
comMapSummer = fromList
   [("Art de la maison - cadeaux - souvenirs"
    , [{ defCom |
         name   = "Legoueix père et fils (été)"
       , refOt  = Just ("6111","http://www.sancy.com/activites/detail/6111/murol/magasin-legoueix")
       , addr   = "Rue du Tartaret 63790 MUROL"
       , tel    = "04 73 88 66 21"
       , descr  = ["Souvenirs"] 
      }]
    )
   ,
   ("Artisanat d'Art, galerie d'art, antiquité"
    , [{ defCom |
         name   = "Cuir Cath"
       , addr   = "Rue George Sand 63790 MUROL"
       , tel    = "06 11 89 14 52"
       , mail   = "cuircath63@orange.fr"
       , descr  = ["Création maroquinerie"] 
      }

      ]
    )
   ,
   ("Produit du terroir"
    , [{ defCom |
         name   = "Lou Cava'yo"
       , refOt  = Just ("8059","http://www.sancy.com/activites/detail/8059/murol/lou-cava-yo")
       , addr   = "Rue Georges Sand - 63790 MUROL"
       , tel    = "06 31 44 19 80"
       , descr  = ["Fromager, produits du terroir"]
      }
      ,{ defCom |
        name   = "Les saveurs d'antan"
      , descr  = ["Produits du terroir"]
      , addr   = "Le Marais - 63790 MUROL"
      , tel    = "04 73 88 69 23"  
      }]
    )
   ,
   ("Alimentation"
    ,[
     { defCom |
       name  = "Jallet"
     , descr = ["Fruits et légumes"]
     , addr  = "Le Marais 63790 MUROL"  
     }
    ]
    )
   ,
   ("Location de materiel skis raquettes"
    ,[
     { defCom |
       name  = "Legoueix père et fils (hiver)"
     , refOt = Just ("6111","http://www.sancy.com/activites/detail/6111/murol/magasin-legoueix")
     , descr = [""]
     , addr  = "Rue du Tartaret 63790 MUROL"
     , tel   = "04 73 88 66 21"  
     }
    ]
    )
   ,

    ("Vêtements"
   , [
     -- { defCom |
     --   name   = "Altitude cottayshop"
     -- , addr   = "rue Georges Sand - 63790 MUROL"
     -- , tel    = ""
     -- , descr  = ["Ouvert du 1 juillet au 30 septembre de 10h00 à 13h00 et de 15h00 à 20h00"
     --            , "Chaussures de randonnée - vêtements divers"]
     -- }
     --,
      { defCom |
        name   = "Toutiveti"
      , addr   = "Route de Besse - parking supermarché SPAR - 63790 MUROL"
      , refOt  = Just ("4234","http://www.sancy.com/activites/detail/4234/murol/toutiveti-vetements") 
      , tel    = "06 76 66 97 47"
      , mail   = "toutiveti@hotmail.fr"
      , descr  = [ "Vêtements/chaussures - hommes/femmes/enfants "]
      }]
   )]