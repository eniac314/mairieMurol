module Agriculture where

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

type alias Agriculteur =
   { name  : String
   , descr : List String
   , addr  : String
   , tel   : String
   , fax   : String
   , mail  : String
   , site  : String
   , refOt : Maybe (String,String)
   }

type alias AgriculteurMap = Dict String (List Agriculteur)

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Vie économique","Agriculture"] (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]

--renderAgriculteurMap : AgriculteurMap -> Html
--renderAgriculteurMap am = 
--  let toDiv k v acc =
--        (div [class "businesses"]
--            ( [ h5 [] [text k]] ++
--                List.map renderAgriculteur v)) :: acc
--      toDivs = Dict.foldr toDiv [] am
--  in div [] toDivs     
  
renderAgriculteurMap : AgriculteurMap -> Html
renderAgriculteurMap am = 
  let toDiv k v acc =
        (div [class "businesses"]
            ( [ h5 [] [text k]] ++
                List.map renderAgriculteur v)) :: acc
      toDivs = Dict.foldr toDiv [] am
      agri   = List.map renderAgriculteur (Maybe.withDefault [] (Dict.get "Agriculteur & producteur de fromages" am))
      col ds = div [class "column", style [("max-width","30%")]] ds

  --in div [] (List.map col (split3' toDivs))
  in div [] 
         ([h5 [] [text "Agriculteur & producteur de fromages: "]] ++ 
         (List.map col (split3' agri)))
  --in div [] toDivs 

renderAgriculteur : Agriculteur -> Html
renderAgriculteur { name, descr, addr, tel, fax, mail, site, refOt} = 
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
      refOt' = case refOt of
                 Nothing ->  nullTag
                 Just (n,ad) -> p [] [ text ("Référence OT: ")
                                     , a [href ad, target "_blank"]
                                         [text n]
                                     ] 
  in div [class "businesses", style [("max-width","95%")]]
         ([name', div [] ([refOt'] ++ descr' ++ [addr', tel', fax', mail', site'])])


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
  div [ class "subContainerData noSubmenu", id "Agriculture"]
      [ h2 [] [text "Agriculture"]
      , renderAgriculteurMap agriMap
      , div [ ]
            [ link "Saint-Nectaire AOP" "http://www.aop-saintnectaire.com/"
            --, p [] [ text "C’est dans une ferme datant de 1970 que 
            --               Josette TIXIER vous accueillera pour vous faire découvrir 
            --               ses secrets de fabrication du saint-Nectaire. Avec son 
            --               fils David à la traite et sa belle-fille 
            --               Angélique à la fromagerie, c’est une affaire de 
            --               famille ! Suite à votre visite de la 
            --               fromagerie, vous aurez droit bien entendu à une 
            --               petite dégustation ! "]
            --, p  [] [ text "Situation Beaune-le-froid, rue de Clermont"]
            --, h5 [] [ text "Visite guidée"]
            --, p  [] [ text "Juillet et août : jeudi, vendredi, samedi à 9h15 (compter 1h)"]
            --, h5 [] [ text "Vente au détail"]
            --, p  [] [ text "Toute l’année, tous les jours (sauf le mardi) de 9h15 à 12h et de 15h à 20h"]
            --, h5 [] [ text "Contactez-nous"]
            --, p  [] [ text "Josette TIXIER, son fils David et son épouse Angélique LAIR"]
            --, p  [] [ text "Tél./Fax. : 04.73.88.62.09"] 
            ]
      ] 

--Data 
defAgri = Agriculteur "" [] "" "" "" "" "" Nothing

agriMap = fromList
  [("Agriculteur & producteur de fromages"
   , [{ defAgri |
        name   = "GAEC de Chautignat"
      , addr   = "Chautignat 63790 Murol"
      , tel    = "04 73 88 81 92"  
      }
     ,
      { defAgri |
        name   = "Tourreix Pascal"
      , addr   = "Beaune Le Froid 63790 Murol"
      , tel    = "04 73 88 62 34" 
      }
     ,
      { defAgri |
        name   = "GAEC Tixier"
      , addr   = "Beaune Le Froid 63790 Murol"
      , tel    = "04 73 88 81 10"
      , refOt  = Just ("4500","http://www.sancy.com/activites/detail/4500/murol/gaec-tixier")
      }
      ,
      { defAgri |
        name   = "GAEC des Monts Dores"
      , addr   = "Beaune le Froid 63790 Murol "
      , tel    = "04 73 88 64 75 "
      , refOt  = Just ("4179","http://www.sancy.com/activites/detail/4179/murol/gaec-des-monts-dore")
      }
      ,
      { defAgri |
        name   = "GAEC des Noisetiers"
      , addr   = "Beaune le Froid 63790 Murol"
      , tel    = "04 73 88 66 32 "
      }
      ,
      { defAgri |
        name   = "GAEC de la route des caves"
      , addr   = "Beaune le Froid 63790 Murol "
      , tel    = "04 73 88 65 85"
      , refOt  = Just ("4181","http://www.sancy.com/activites/detail/4181/murol/gaec-de-la-route-des-caves-ferme-roux")
      }
      ,
      { defAgri |
        name   = "Laurent PLANEIX"
      , addr   = "Beaune le Froid 63790 Murol"
      , tel    = "04 73 88 60 74 "
      }
      ,
      { defAgri |
        name   = "Philippe BEAL"
      , addr   = "Les Ballats 63790 Murol"
      , tel    = "04 73 88 60 47 "
      }
      ,
      { defAgri |
        name   = "Daniel BOUCHE"
      , addr   = "Beaune le Froid 63790 Murol"
      , tel    = "04 73 88 67 28 "
      }
      ]
   ) 
  ]
