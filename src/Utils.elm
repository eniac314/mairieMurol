module Utils where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Date exposing (..)



-- Main Menu

type alias Link    = String
type alias Label   = String
type alias Visible = Bool

type Menu = Leaf Label Link | Node Label (List Menu)

mainMenu : Menu
mainMenu = Node ""
  [ Leaf "Accueil" "index.html"
  , Leaf "Animation" ""
  , Node "Tourisme"
         [ Leaf "Office de Tourisme" ""
         , Leaf "Découvrir Murol" ""
         , Leaf "Hébergements" ""
         , Leaf "Restaurants" ""
         , Leaf "Carte & plan" ""
         , Leaf "Animation estivale" "" 
         ]
  , Node "Vie locale"
         [ Leaf "Vie scolaire" ""
         , Leaf "Péri et extra-scolaire" ""
         , Leaf "Les seniors" ""
         , Leaf "Santé" ""
         , Leaf "Transports" ""
         , Leaf "Gestion des déchets" ""
         , Leaf "Animaux" ""
         ]
  , Node "Vie économique"
         [ Leaf "Agriculture" ""
         , Leaf "Commerces" ""
         , Leaf "Entreprises" ""
         , Leaf "Offres d'emploi" ""
         ]
  , Node "Mairie"
         [ Leaf "La commune" ""
         , Leaf "Conseil municipal" ""
         , Leaf "Délibérations" ""
         , Leaf "Commissions" ""
         , Leaf "CCAS" ""
         , Leaf "Vos démarches" ""
         , Leaf "Salles municipales" ""
         , Leaf "Horaires et contact" ""
         ]
  , Node "Culture et loisirs"
         [ Leaf "Artistes" ""
         , Leaf "Associations" ""
         , Leaf "Sortir" ""
         , Leaf "Patrimoine" ""
         , Leaf "Sports et détente" ""
         , Leaf "Photothèque" ""
         ]
  , Node "Documentation"
         [ Leaf "Bulletins municipaux" ""
         , Leaf "Murol Infos" ""
         , Leaf "Délibérations" ""
         , Leaf "Gestion des risques" ""
         , Leaf "Elections" ""
         , Leaf "Autres publications" ""
         , Leaf "Village fleuri" ""
         , Leaf "Service-public.fr" "https://www.service-public.fr/"
         ]
  , Leaf "Petites annonces" ""]


--renderMainMenu : List String -> Menu -> Html
--renderMainMenu pos m  = 
--  let toUrl s =
--    s |> words
--      |> List.map capitalize
--      |> join ""
--      |> (\s -> s ++ ".html")
--      current label = ("current", List.member label pos)

--  in case m of
--    Leaf label link -> 
--      let link' = if String.isEmpty link
--                  then toUrl label
--                  else link
--      in  a [ href link', classList [current label]]
--            [ text label]
         

--    Node label xs ->
--      if String.isEmpty label
      
--      then nav [ class "mainMenu" ]
--               (List.map (renderMainMenu pos) xs)  
--      else
--        nav [ class (label ++ "Content")]
--            ([ a [ classList [ ((label ++ "dropBtn"),True)
--                             , current label
--                             ]
--                 ]
--                 [ text label ]
--             , nav [] (List.map (renderMainMenu pos) xs)
--             ])

renderMainMenu : List String -> Menu -> Html
renderMainMenu pos m  = 
  let toUrl s =
    s |> words
      |> List.map capitalize
      |> join ""
      |> (\s -> s ++ ".html")
      current label = ("current", List.member label pos)

  in case m of
    Leaf label link -> 
      let link' = if String.isEmpty link
                  then toUrl label
                  else link
      in  a [ href link', classList [current label]]
            [ text label]
         

    Node labelName xs ->
      if String.isEmpty labelName
      
      then nav [ class "mainMenu" ]
               (List.map (renderMainMenu pos) xs)  
      else
        nav [ class (labelName ++ "Content")]
            ([ label [ classList [ ((labelName ++ "dropBtn"),True)
                             , current labelName
                             ]
                 , for (labelName)
                 ]
                 [ text labelName ]
             , input [type' "radio",name "menuRadio", id labelName] []
             , nav [] (List.map (renderMainMenu pos) xs)
             ])

-- SubMenu

type alias Submenu =
  { current : String 
  , entries : List String
  }

type Action
  = NoOp
  | Entry String 

renderSubMenu address title submenu =
  let es    = .entries submenu 
      pos   = .current submenu
      isCurrent e = classList [("submenuCurrent", e == pos)]
      toA e = a [id e, onClick address (Entry e), href "#", isCurrent e]
                [text e]
      linkList = List.map toA es
  in
  div [ class "sideMenu"]
      [ h3  [] [text (title)]
      , div [] linkList
      ]


-- Logos
logos    = [("famillePlus.jpg","http://www.familleplus.fr/fr")
           ,("Station_Tourisme_RVB.jpg","http://www.entreprises.gouv.fr/tourisme/communes-touristiques-et-stations-classees-tourisme")
           ,("Village fleuri.png","http://www.villes-et-villages-fleuris.com/")
           ,("StationVertegf.jpg","http://www.stationverte.com/")
           ,("PAVILLON BLEU LOGO 2.png","http://www.pavillonbleu.org/")
           ]

renderListImg pics =
  div [id "pics"]
      [ ul []
           (List.map (\(i,l) -> li [] [a [href l, target "_blank"] [img [src ("/images/" ++ i)] []]]) pics)]


-- Footer
pageFooter = 
  footer [ id "footer"]
         [div[]
             [p [] [ text "Vous souhaitez passer une information: "
                   , a [href ("mailto:"++"contactsite.murol@orange.fr")]
                       [text " contactez le webmaster"]
                   ]
             ]
          , p [] [text "La mairie: "
                 , a [href "HorairesEtContact.html"]
                     [text "horaires et contact"]
                 ]    
          , renderCounter
         ] 

renderCounter = 
  div [ id "counter"]
      [ script "" "var sc_project=10774754; var sc_invisible=0; var sc_security=\"74787ab4\"; var scJsHost = ((\"https:\" == document.location.protocol) ?\"https://secure.\" : \"http://www.\");document.write(\"<sc\"+\"ript type='text/javascript' src='\" +scJsHost+\"statcounter.com/counter/counter.js'></\"+\"script>\");"
      , div [class "statcounter"]
            [ text "Compteur: "
            , a [title "web statistics"
               , href "http://statcounter.com/free-web-stats/"
               , target "_blank"
               ]
               [ img [ class "statcounter"
                     , src "http://c.statcounter.com/10774754/0/74787ab4/0/"
                     , alt "web statistics"
                     ]
                     []
               ]
            ]   
      , script "" "  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

                  ga('create', 'UA-75068519-1', 'auto');
                  ga('send', 'pageview');"
      ]

-- Misc

months' date = 
  case Date.month date of
    Jan -> "01" 
    Feb -> "02"
    Mar -> "03"
    Apr -> "04"
    May -> "05"
    Jun -> "06"
    Jul -> "07"
    Aug -> "08"
    Sep -> "09"
    Oct -> "10"
    Nov -> "11"
    Dec -> "12"

day' date  = 
  let res = toString (Date.day date)
  in if  String.length res == 1
     then "0"++res
     else res
     
year' date = toString (Date.year date)

capitalize : String -> String
capitalize string =
  case uncons string of
   Nothing -> ""
   Just (head, tail) ->
      cons (Char.toUpper head) tail

script : String -> String -> Html
script source js =
  node "script" [src source, type' "text/javascript"] [text js]


mail s  = span [class "email"] [ text "Email: "
         , a   [href ("mailto:"++s)] [text s]
         ]

site tex addr =
 span [] [ text "Site: "
         , a [href addr, target "_blank"] [text (prettyUrl tex)]
         ]

link tex addr = a [href addr, target "_blank"] [text (prettyUrl tex)]

maybeElem : String -> ( String -> Html ) -> Html
maybeElem s f =
  if String.isEmpty s
  then nullTag
  else f s

nullTag = span [style [("display","none")]] []

split3 xs (xs1,xs2,xs3) = 
        case xs of
          [] -> (xs1,xs2,xs3)
          (x1::[]) -> (x1::xs1,xs2,xs3)
          (x1::x2::[]) -> (x1::xs1,x2::xs2,xs3)
          (x1::x2::x3::xs') -> split3 xs' (x1::xs1,x2::xs2,x3::xs3)

split3' xs =
  let l = ceiling (toFloat (List.length xs) / 3)
      chunk n xs = 
        case xs of 
          []  -> []
          xs' -> (List.take n xs') :: chunk n (drop n xs')
  in chunk l xs  

miniLightBox : String -> Html
miniLightBox name = 
  div [ class ("miniLightboxWrapper" ++ name)]
      [ a [ href ("#"++ name ++"Big")
          , id (name ++ "Small")
          , class "thumbAnchor"
          , title "Cliquez sur l'image pour agrandir"] 
          
          [ img [ src ("/images/"++name ++"Small.jpg")
                , id (name ++ "Small")] []
                , i   [class "fa fa-expand"] []
                ]
              
      , a [ href "#_"
          , class "miniLightbox"
          , id (name ++ "Big")] 
          [ img [src ("/images/"++name ++"Big.jpg")]
                []
          ]
      ]

prettyUrl : String -> String
prettyUrl url = 
  if String.startsWith "http://www" url
  then String.dropLeft 7 url
  else url