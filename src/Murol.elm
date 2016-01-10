module Murol where


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (..)
import StartApp as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Task
import TiledMenu
import Date exposing (..)

-- Model

type alias Model = 
  { mainMenu    : Menu
  , logos       : List (String,String)
  , newsletters : List (String,String)
  , news        : List News
  , newsMairie  : List News
  , misc        : List (String,String)
  }

type alias News = 
  { title : String
  , date  : Result String Date
  , descr : Html
  , pic   : Maybe String
  , drop  : Bool
  , id    : Int
  }


type alias Submenu =
  { current : String 
  , entries : List String
  }  

emptyNews = News "" (Err "") nullTag Nothing False 0

tag i n xs =
 case xs of
      [] -> []
      (x::xs') -> {x | id = i+n} :: tag i (n+1) xs'  

dropN id n = if .id n == id
             then {n | drop = not (.drop n)}
             else n 

newstime news = 
 case .date news of 
   Err s  -> 0
   Ok  d' -> Date.toTime d'


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
         , Leaf "Les séniors" ""
         , Leaf "Santé" ""
         , Leaf "Transports" ""
         , Leaf "Gestion des déchets" ""
         ]
  , Node "Vie économique"
         [ Leaf "Agriculture" ""
         , Leaf "Commerces" ""
         , Leaf "Entreprises" ""
         , Leaf "Offres d'emploi" ""
         ]
  , Node "Mairie"
         [ Leaf "La commune" ""
         , Leaf "Vos démarches" ""
         , Leaf "Conseil municipal" ""
         , Leaf "CMJ" ""
         , Leaf "CCAS" ""
         , Leaf "Commissions" ""
         , Leaf "Gestion des risques" ""
         , Leaf "Horaires et contact" ""
         , Leaf "Publications" ""
         ]
  , Node "Culture et loisirs"
         [ Leaf "Art et musique" ""
         , Leaf "Artisanat d'art" ""
         , Leaf "Associations" ""
         , Leaf "Cinema" ""
         , Leaf "Musée des peintres" "http://www.musee-murol.fr/fr"
         , Leaf "Patrimoine" ""
         , Leaf "Phototheque" ""
         , Leaf "Sports et détente" ""
         , Leaf "Village fleuri" ""
         ]
  , Leaf "Numeros d'urgences" ""
  , Leaf "Petites annonces" ""]

--logos    = ["FamillePlus2.gif"
--           ,"StationTourismeRVB2.gif"
--           ,"Villagefleuri2.gif"
--           ,"StationVertegf2.gif"
--           ]

logos    = [("famillePlus.jpg","http://www.familleplus.fr/fr")
           ,("Station_Tourisme_RVB.jpg","http://www.communes-touristiques.net/")
           ,("Village fleuri.png","http://www.villes-et-villages-fleuris.com/")
           ,("StationVertegf.jpg","http://www.stationverte.com/")
           ]


initialModel = 
  { mainMenu    = mainMenu
  , logos       = logos
  , newsletters = newsletters
  , misc        = misc
  , news        = tag 0 0 (reverse (List.sortBy newstime news))
  , newsMairie  = tag 0 100 (reverse (List.sortBy newstime newsMairie))
  }



-- Update
type Action 
  = NoOp
  | Hover String
  | Entry String
  | Drop  Int
  --| ScrollY Int


update action model =
  case action of 
    NoOp    -> (model, none)
    Hover s -> (model, none)
    Entry e -> (model, none)
    --ScrollY r -> (model, none)
    Drop id -> 
      let n1 = List.map (dropN id) (.news model)
          n2 = List.map (dropN id) (.newsMairie model)
      in ({ model | news = n1, newsMairie = n2 }, none)





-- View

renderContent n1 n2 address = 
  div [ class "subContainerData", id "index"]
      [ renderNewsList address "Actualités de la commune" n1
      , renderNewsList address "La mairie vous informe" n2
      , renderListImg logos
      ]

renderMainMenu : Signal.Address Action -> List String -> Menu -> Html
renderMainMenu adr pos m  = 
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
    
    Node label xs ->
      if String.isEmpty label
      
      then div [ class "mainMenu"]
               (List.map (renderMainMenu adr pos) xs)  
      else
        div [ class (label ++ "Content")]
            ([ a [ classList [ ((label ++ "dropBtn"),True)
                             , current label
                             ]
                 ]
                 [ text label ]
             , div [] (List.map (renderMainMenu adr pos) xs)
             ])


renderMainMenu' : List String -> Menu -> Html
renderMainMenu' pos m  = 
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
         

    Node label xs ->
      if String.isEmpty label
      
      then div [ class "mainMenu"]
               (List.map (renderMainMenu' pos) xs)  
      else
        div [ class (label ++ "Content")]
            ([ a [ classList [ ((label ++ "dropBtn"),True)
                             , current label
                             ]
                 ]
                 [ text label ]
             , div [] (List.map (renderMainMenu' pos) xs)
             ])

pageFooter = 
  footer [ id "footer"]
         [div[]
             [p [] [ text "Vous souhaitez passer une information"
                   , a [href ""] [text " contactez le webmaster"]
                   ]
             ]
              
          , renderCounter
         ] 


 
renderListImg pics =
  div [id "pics"]
      [ ul []
           (List.map (\(i,l) -> li [] [a [href l] [img [src ("/images/" ++ i)] []]]) pics)]


renderNewsList : Signal.Address Action -> String -> List News -> Html
renderNewsList address title xs =
  div [class (title |> words |> List.map capitalize |> join "")]
      ([ h4 [] [text title]]
      ++ (List.map (renderNews address) xs))

renderNews : Signal.Address Action -> News -> Html
renderNews address { title, date, descr, pic, drop, id} =
  let date' = 
       case date of
        Err s -> s
        Ok d  -> (day' d)
                 ++ " " ++
                 (months' d)
                 ++ " " ++
                 (year' d)  

      pic' = 
       case pic of 
        Nothing -> nullTag
        Just  p -> img [src ("/images/news/" ++ p), class "newspic"] []

      body = if drop
             then div [class "newsBody"][ pic', descr]
             else nullTag 
      arrow = if drop
              then img [src "/images/uArrow.jpeg"] []
              else img [src "/images/dArrow.jpeg"] [] 

  in 
  div [class "news"]
      [ div [class "newsHeader"] 
            [ h5 [class "newsTitle", onClick address (Drop id)]
                 [text title]
            , span [class "date"] [text date']
            , span [class "arrow"] [arrow]
            ]
      , body
      ]



renderNewsLetter news =
  let toNews (content,address) =
        a [href address] [li [] [text content]] 
      newsList = List.map toNews news
  in
  div [id "newsletters", class "submenu entry"]
      [ h3 [] [text "Inscrivez vous"]
      , ul [] newsList
      ]

renderMisc misc =
  let toLink (content,address) =
        a [href address] [li [] [text content]] 
      linkList = List.map toLink misc
  in
  div [id "misc", class "submenu entry"]
      [ h3 [] [text "Divers"]
      , ul [] linkList
      ]

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

renderMeteo = 
  div [ id "meteo"]
      [ a [ id "lcm2K13_1000"
          , href "http://france.lachainemeteo.com/meteo-france/ville
                  /previsions-meteo-murol-3657-0.php"] []
      , script "http://services.lachainemeteo.com/meteodirect/generationjs/javascript?type_affichage=vignette&w=140&h=175&idc=lcm2K13&entite=3657&type_entite=1&echeance=0&rand=1000" ""
      ]

renderEtatRoutes = 
  div [ id "EtatRoutes"]
      [ a [ href "/Carte&Plan.html#infoRoute"]
          [ img [src "/images/routes.jpg"] [] 
          , figcaption [] [text "Etat des routes"] 
          ]
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
      , script "" "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create', 'UA-72224642-1', 'auto');ga('send', 'pageview');"
      ]       

renderPlugins =
  div [ id "plugins", class "submenu"]
      [ h3 [] [text "Pratique"]
      , ul []
           (List.map (\p -> li [] [p]) [renderMeteo, renderEtatRoutes])
      ]

renderAgenda = 
  div [id "agenda", class "submenu"]
      [ h3 [] [text "Agenda"]
      , iframe [ src "https://calendar.google.com/calendar/embed?showTitle=0&showTabs=0&showNav=0&showPrint=0&showCalendars=0&showTz=0&mode=AGENDA&height=150&wkst=2&hl=fr&bgcolor=%23FFFFFF&src=uminokirinmail%40gmail.com&color=%231B887A&ctz=Europe%2FParis"
               ] []
      , p [] [a [href "https://calendar.google.com/calendar/embed?src=uminokirinmail%40gmail.com&ctz=Europe/Paris"]
                [text "Consulter le calendrier"]
             ]
      , p [] [a [href "/Animation.html"] [text "Programmes des manifestations"]]
      ] 
      


view : Signal.Address Action -> Model -> Html
view address model =
  div [id "container"]
      [ renderMainMenu address ["Accueil"] (.mainMenu model) 
      , div [ id "subContainer"]
            [ renderContent (.news model) (.newsMairie model) address
            , div [class "sidebar"]
                  [ renderAgenda
                  , renderPlugins
                  , renderNewsLetter (.newsletters model)
                  , renderMisc (.misc model)
                  ]
            ]
      , pageFooter 
      ]

app =
    StartApp.start
          { init = (initialModel, none)
          , view = view
          , update = update
          , inputs = []
          }

main =
    app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

--main =
--  StartApp.start
--    { model  = initialModel
--    , view   = view
--    , update = update
--    }

--scrollYInbox : Signal.Mailbox String
--scrollYInbox = Signal.mailbox "5"

--scrollYEvent = on "scrollY" targetValue
--                (\s -> Signal.message scrollYInbox.address s)

--messages = scrollYInbox.signal

--port scrollY : Signal Int

--scrollYAct = Signal.map  ScrollY scrollY




-- Utils

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

day' date  = toString (Date.day date)
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


mail s  = span [] [ text "Email: "
         , a [href ("mailto:"++s)] [text s]
         ]

site tex addr =
 span [] [ text "Site: "
         , a [href addr] [text tex]
         ]

link tex addr = a [href addr] [text tex]

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

-- Data
 
news : List News
news = 
  [{ emptyNews |
     title = "L'Auvergne dans le Best of de Lonely Planet"
   , date  = Date.fromString "10/29/2015"
   , descr = div [class "newsdescr"]
                 [p [] [text "L'Auvergne fait une entrée remarquée dans le Best
                              of du voyage de Lonely Planet en 2016.
                              En 6ème position du classement des régions
                              à visiter dans le monde"]
                 , link "Source" "http://www.lonelyplanet.fr/article/lauvergne-6eme-region-du-monde-visiter-en-2016"
                 ]
   , pic   = Just "lonely.png"            
   }
  ,{ emptyNews |
     title = "Chant de Noël à l'église de Beaune le Froid"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [ text " Samedi 19 à 15h à l'église de Beaune le Froid, chant de Noël
                                 avec l'ensemble instrumental de la vallée verte et la
                                 chorale de Murol"]
                 ]
   }
  ,{ emptyNews |
     title = "Noël des enfants à la salle des fêtes de Murol"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [ text "Dimanche 20 à 14h, Noël des enfants à la salle des fêtes de Murol.
                                Une collecte  de denrée alimentaire sera réalisé à cette occasion
                                au profit de la banque alimentaire."]
                 ]
   }
  ,{ emptyNews |
     title = "Animations de Noêl "
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [text "Lundi 21 toute la journée, rue G. Sand,
                              animations de Noêl organisées par les commerçants."]]
   }
  ,{ emptyNews |
     title = "Chasse au trésor de Noël"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [text "Lundi 21 à 15h, chasse au trésor de Noël."]]
   }
  ,{ emptyNews |
     title = "3 contes de Noël"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Pour Noël : 3 contes de Noël."]
                 , link "lien" "" 
                 ]
   }                
  ]

newsMairie : List News
newsMairie =
  [{ emptyNews |
     title = "Nouveaux horaires navette"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [ p  [] [text "les nouveaux horaires de la Navette Chambon/Lac - Murol - Saint Nectaire ---- Clermont Ferrand"]
                 , link "Télécharger les horaires" ""
                 , br [] []
                 , link "Dépliant ligne 74 navette" ""  
                 ]
   }
   ,
   { emptyNews |
     title = "Application vols/cambriolage"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [ p  [] [text "Une application a été créée par les gendarmes 
                                pour faire l'inventaire de biens en cas de vols
                                 ou de cambriolages: \" Cambrio-Liste \"."]
                 , link "lien Apple-Store" ""
                 , br [] []
                 , link "lien Google Play" "" 
                 ]
   }
   ,
   { emptyNews |
     title = "Permanence mission locale pour l'emploi"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [ p  [] [text "1er lundi de chaque mois permanence mission locale pour l'emploi."]
                 ]
   }
   ,
   { emptyNews |
     title = "Vente de terrain communaux"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [link "Contactez la mairie" "" 
                 ]
   }
   ,
   { emptyNews |
     title = "Simplification du système administratif français"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Le système administratif français nécessite une
                               simplification. Un site a été créé afin de recueillir
                               des suggestions d'amélioration dans les
                                démarches administratives. En savoir plus sur "]
                 , link "http://www.faire-simple.gouv.fr/" "http://www.faire-simple.gouv.fr/" 
                 ]
   }
  ]

newsletters =
  [("Aux bulletins d'informations de la commune"
   ,"https://docs.google.com/forms/d/1sAJ3usxihhBxeY6SNyr2v3JI98Ii27QL-7N_Yjtw4v8/viewform"
   )
   ,
   ("Aux commissions"
   ,"https://docs.google.com/forms/d/1RzrxYsue2UqQn2VBdPK3AamNAUb1IyejhWfENwjynkA/viewform"
   )
   ,
   ("Recevoir une alerte mise à jour site"
   ,"https://docs.google.com/forms/d/1sAJ3usxihhBxeY6SNyr2v3JI98Ii27QL-7N_Yjtw4v8/viewform"
   )
  ]

misc = 
  [("Visiter le musée des peintres de Murol","http://www.musee-murol.fr/fr")] 



