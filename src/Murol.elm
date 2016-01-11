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
  --, newsMairie  : List News
  --, misc        : List (String,String)
  }

type alias News = 
  { title  : String
  , date   : Result String Date
  , descr  : Html
  , pic    : Maybe String
  , drop   : Bool
  , id     : Int
  , expiry : Result String Date 
  }


type alias Submenu =
  { current : String 
  , entries : List String
  }  

emptyNews = News "" (Err "") nullTag Nothing False 0 (Err "")

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
  , news        = prepNews "01/11/2016" news
  }


prepNews : String -> List News -> List News
prepNews t ns = 
  let today = Result.withDefault
               (Date.fromTime 0)
               (Date.fromString t)

      relevant = removeOld today ns
  in tag 0 0 (reverse (List.sortBy newstime relevant))

removeOld : Date -> List News -> List News
removeOld today ns = 
  let p n =
    let expiry' = Result.withDefault today (.expiry n)
    in  (Date.toTime expiry') >= (Date.toTime today)
  in List.filter p ns


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
      in ({ model | news = n1 }, none)





-- View

renderContent n1 address = 
  div [ class "subContainerData", id "index"]
      [ renderNewsList address "Actualités de la commune" n1
      , renderListImg logos
      , renderMisc
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
             [p [] [ text "Vous souhaitez passer une information: "
                   , a [href ("mailto:"++"uminokirinmail@gmail.com")]
                       [text " contactez le webmaster"]
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
      ([ h4 [] [text title]
       , p  [ id "lastUpdate" ]
            [text "Dernière mise à jour le lundi 11 janvier 2016"]
       ]
      ++ (List.map (renderNews address) xs))

renderNews : Signal.Address Action -> News -> Html
renderNews address { title, date, descr, pic, drop, id, expiry} =
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

renderMisc =
  div [ id "misc", class "divers"]
      [ h4 [] [text "Divers"]
      , div []
            [ a [href "http://www.musee-murol.fr/fr"]
            [text "Visiter le musée des peintres de Murol"]]
      --, img [src "/images/peintres.png"] [] 
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
      , p [] [a [href "/Animation.html"]
                [text "Consulter le calendrier"]
             ]
      , p [] [a [href "/Animation.html"] [text "Programmes des manifestations"]]
      ] 
      


view : Signal.Address Action -> Model -> Html
view address model =
  div [id "container"]
      [ renderMainMenu address ["Accueil"] (.mainMenu model) 
      , div [ id "subContainer"]
            [ renderContent (.news model) address
            , div [class "sidebar"]
                  [ renderAgenda
                  , renderPlugins
                  , renderNewsLetter (.newsletters model)
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
                              à visiter dans le monde: "
                 , link "Source" "http://www.lonelyplanet.fr/article/lauvergne-6eme-region-du-monde-visiter-en-2016"]
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
   , expiry = Date.fromString "12/25/2015"
   }
  ,{ emptyNews |
     title = "Noël des enfants à la salle des fêtes de Murol"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [ text "Dimanche 20 à 14h, Noël des enfants à la salle des fêtes de Murol.
                                Une collecte  de denrée alimentaire sera réalisé à cette occasion
                                au profit de la banque alimentaire."]
                 ]
   , expiry = Date.fromString "12/25/2015"
   }
  ,{ emptyNews |
     title = "Animations de Noêl "
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [text "Lundi 21 toute la journée, rue G. Sand,
                              animations de Noêl organisées par les commerçants."]]
   , expiry = Date.fromString "12/25/2015"
   }
  ,{ emptyNews |
     title = "Chasse au trésor de Noël"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [p [] [text "Lundi 21 à 15h, chasse au trésor de Noël."]]
   , expiry = Date.fromString "12/25/2015"
   }
  ,{ emptyNews |
     title = "3 contes de Noël"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Pour Noël : 3 contes de Noël."]
                 , link "lien" "" 
                 ]
   , expiry = Date.fromString "12/25/2015"
   }
   ,{ emptyNews |
     title = "Murol Infos 28"
   , date  = Date.fromString "01/11/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" (janvier 2016) est disponible: "
                    , a [href "baseDocumentaire/MUROL INFOS 28.doc"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "02/11/2016"
   }
   ,{ emptyNews |
     title = "Recensement de la population à Murol"
   , date  = Date.fromString "01/11/2016"
   , descr = div [ class "newsdescr"]
                 [ p [] [text "Il aura lieu du 21 janvier au 20 février 2016."]
                 , p [] [text "Le recensement permet de déterminer la population officielle 
                               de chaque commune."]
                 , p [] [text "Il fournit également des informations sur les caractéristiques 
                               de la population : âge, profession, moyens de 
                               transport utilisés, conditions de logement... "]
                 , p [] [text "De ces chiffres découle la participation de l'État 
                               au budget des communes : plus une commune 
                               est peuplée, plus cette participation est importante."]
                 , p [] [text "Du nombre d'habitants dépendent également le nombre d'élus 
                               au conseil municipal, la détermination du mode de 
                               scrutin... "]
                 , p [] [text "Plus de détails dans le dernier "
                        , a [href "baseDocumentaire/MUROL INFOS 28.doc"]
                            [text "Murol Infos"]
                        ]   
                 ]
   , expiry = Date.fromString "02/21/2016"
   }
   ,{ emptyNews |
     title = "Voeux du Maire"
   , date  = Date.fromString "01/11/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Comme chaque année, le maire, Sébastien Gouttebel,
                           présentera ses vœux à la population murolaise. "]
                 , p []
                     [text "Il dressera le bilan de l’année 2015 et 
                           vous informera sur l’avancée des projets en cours. 
                           Vous pourrez également voir le diaporama de l’année 
                           2015 réalisé à partir des photos fournies par 
                           Michel Martin, correspondant du journal la Montagne. "]
                 , p []
                     [text "Rendez-vous le 24 janvier à 11 heures, à la salle des fêtes de Murol."]
                 ]
   , expiry = Date.fromString "01/25/2016"
   }    
   --,{ emptyNews |
   --  title = ""
   --, date  = Date.fromString ""
   --, descr = div [class "newsdescr"]
   --              []
   --, expiry = Date.fromString ""
   --}                
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





