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

      col ds = div [class "column"] ds

  in div [] (List.map col (split3' toDivs)) 

renderAgriculteur : Agriculteur -> Html
renderAgriculteur { name, descr, addr, tel, fax, mail, site} = 
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
  div [ class "subContainerData noSubmenu", id "Agriculture"]
      [ h2 [] [text "Agriculture"]
      , renderAgriculteurMap agriMap
      , div [ ]
            [ link "Saint-Nectaire AOP" "http://www.fromages-aop-auvergne.com/AOP-Saint-Nectaire"
            , p [] [ text "C’est dans une ferme datant de 1970 que 
                           Josette TIXIER vous accueillera pour vous faire découvrir 
                           ses secrets de fabrication du saint-Nectaire. Avec son 
                           fils David à la traite et sa belle-fille 
                           Angélique à la fromagerie, c’est une affaire de 
                           famille ! Suite à votre visite de la 
                           fromagerie, vous aurez droit bien entendu à une 
                           petite dégustation ! "]
            , p  [] [ text "Situation Beaune-le-froid, rue de Clermont"]
            , h5 [] [ text "Visite guidée"]
            , p  [] [ text "Juillet et août : jeudi, vendredi, samedi à 9h15 (compter 1h)"]
            , h5 [] [ text "Vente au détail"]
            , p  [] [ text "Toute l’année, tous les jours (sauf le mardi) de 9h15 à 12h et de 15h à 20h"]
            , h5 [] [ text "Contactez-nous"]
            , p  [] [ text "Josette TIXIER, son fils David et son épouse Angélique LAIR"]
            , p  [] [ text "Tél./Fax. : 04.73.88.62.09"] 
            ]
      ] 

--Data 
defAgri = Agriculteur "" [] "" "" "" "" ""

agriMap = fromList
  [("Agriculteur & producteur de fromages"
   , [{ defAgri |
        name   = "GAEC de Chautignat"
      , addr   = "Chautignat - 63790 Murol"
      , tel    = "04 7388 8192"  
      }
     ,
      { defAgri |
        name   = "Tourreix Pascal"
      , addr   = "Beaune Le Froid 63790 MUROL"
      , tel    = "04 7388 6234 ou 09 6149 3912" 
      }
     ,
      { defAgri |
        name   = "Tixier David"
      , addr   = "Beaune Le Froid 63790 MUROL"
      , tel    = "04 7388 8110"  
      }]
   ) 
  ]
