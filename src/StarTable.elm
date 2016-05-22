module StarTable where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Utils exposing (prettyUrl)
import String exposing (words, join, cons, uncons)

addStars : Maybe Int -> String -> String ->  Html
addStars n e s =
  let go n = if n == 0
             then ""
             else  "★" ++ go (n-1)
  in case n of
       Nothing -> 
        if String.isEmpty e 
        then text s
        else  span []
                   [text (s ++ " - ")
                   , span [ class "epis"]
                          [ text e]
                   ]
       Just n' ->
         span []
              [ text ( s ++ " ")
              , span [ class "stars"]
                     [ text (go n') ]
              ]

type Label = FamillePlus | NoLabel

type alias TableEntry =
   { name  : String
   , label : Label
   , stars : Maybe Int
   , epis  : String
   , refOt : Maybe (String,String)
   , descr : List String
   , addr  : String
   , tel   : String
   , fax   : String
   , mail  : String
   , site  : String
   , pjaun : String
   , pics  : List String
   }

 
emptyTe = TableEntry "" NoLabel Nothing "" Nothing [] "" "" "" "" "" "" []

makeTable : String -> List TableEntry -> Html
makeTable name entries =
  let
  makeRows b xs =
    case xs of
      [] -> []
      (e::xs') ->
        makeRow e b :: makeRows (not b) xs'
  in table [id name] (makeRows True entries)


makeRow : TableEntry -> Bool -> Html
makeRow { name, label, stars, epis, refOt, descr,
           addr, tel, fax, mail, site, pjaun, pics } alt =
  let name'  = h6 [] [addStars stars epis name]

      label' = labelToHtml label

      addr'  = maybeElem
                addr (\s -> p [] [text s])

      mail'  = maybeElem
                mail (\s -> p [] [text "e.mail: ", a [href ("mailto:"++s)] [text s]])

      site'  = maybeElem
                site (\s -> p [] [text "site: ", a [href s, target "_blank"] [text (prettyUrl s)]])

      pjaun'  = maybeElem
                 pjaun (\s -> p [] [text "Pages Jaunes: ", a [href s] [text s]])

      descr' = List.map (\s -> p [] [text s]) descr

      refOt' = case refOt of
                 Nothing ->  nullTag
                 Just (n,ad) -> p [] [ text ("Référence OT: ")
                                     , a [href ad, target "_blank"]
                                         [text n]
                                     ] 

      tel'   = maybeElem
                tel (\s -> p [] [text ("Tel. " ++ s)])
      fax'   = maybeElem
                fax (\s -> p [] [text ("Fax : " ++ s)])

      pics'  = div [] (List.map (\s -> img [src s] []) pics)

      alt'   = if alt then "altLine" else "Line"

  in tr [ class alt']
        [ td []
             ( [ name', label', refOt'] ++ descr' ++
              [ addr', tel', fax', mail', site', pjaun'] )
        , td [] [ pics']
        ]

-- Utils
maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

labelToHtml l =
  case l of
    NoLabel     -> nullTag
    FamillePlus -> nullTag
