module Murol where


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Date exposing (..)

-- Model

type alias Model = 
  { mainMenu    : Menu
  , logos       : List  String
  , mainContent : Html
  , newsletters : List (String,String)
  , misc        : List (String,String)
  }

type alias News = 
  { title : String
  , date  : Result String Date
  , descr : Html
  , pic   : Maybe String
  }


emptyNews = News "" (Err "") nullTag Nothing 

type alias Link    = String
type alias Label   = String
type alias Visible = Bool

type Menu = Leaf Label Link | Node Label (List Menu)

mainMenu : Menu
mainMenu = Node ""
  [ Leaf "Accueil" "index.html"
  , Leaf "Agenda" ""
  , Leaf "Tourisme" ""
  , Node "Vie locale"
         [ Leaf "Vie scolaire" ""
         , Leaf "Les séniors" ""
         , Leaf "Covoiturage" ""
         , Leaf "Gestion des déchets" ""
         ]
  , Node "Vie économique"
         [ Leaf "Agriculture" ""
         , Leaf "Artisanat" ""
         , Leaf "Commerces" ""
         , Leaf "Entreprises" ""
         , Leaf "Offres d'emploi" ""
         , Leaf "Quinzaine commerciale" ""
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

logos    = ["FamillePlus2.gif"
           ,"StationTourismeRVB2.gif"
           ,"Villagefleuri2.gif"
           ,"StationVertegf2.gif"
           ]






initialModel = 
  { mainMenu    = mainMenu
  , logos       = logos
  , mainContent = initialContent
  , newsletters = newsletters
  , misc        = misc
  }



-- Update
type Action 
  = NoOp
  | Hover String
  | Entry String


update action model =
  case action of 
    NoOp    -> model
    Hover s -> model
    Entry e -> model


-- View

renderMainMenu : Signal.Address Action -> Menu -> Html
renderMainMenu adr m = 
  let toUrl s =
    s |> words
      |> map capitalize
      |> join ""
      |> (\s -> s ++ ".html")
  in case m of
    Leaf label link -> 
      let link' = if String.isEmpty link
                  then toUrl label
                  else link
      in  a [ href link']
            [ text label]
         

    Node label xs ->
      if String.isEmpty label
      
      then div [ class "mainMenu"]
               (List.map (renderMainMenu adr) xs)  
      else
        div [ class (label ++ "Content")]
            ([ a [ class (label ++ "dropBtn")
                 ]
                 [ text label ]
             , div [] (List.map (renderMainMenu adr) xs)
             ])

pageFooter = 
  footer [ id "footer"]
         [ renderListImg logos
         , p [] [ text "Vous souhaitez passer une information"
                , a [href ""] [text " contactez le webmaster"]
                ]
         ] 


 
renderListImg pics =
  div [id "pics"]
      [ ul []
           (map (\e -> li [] [img [src ("/images/" ++ e)] []]) pics)]


renderNewsList : String -> List News -> Html
renderNewsList title xs =
  div [class title]
      ([ h4 [] [text title]]
      ++ (List.map renderNews xs))

renderNews : News -> Html
renderNews { title, date, descr, pic} =
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
        Just  p -> img [src ("/images/news/" ++ p)] []  
  in 
  div [class "news"]
      [ h5 [class "newsTitle"] [text title]
      , span [class "date"] [text date']
      , pic'
      , descr
      ]



renderNewsLetter news =
  let toNews (content,address) =
        a [href address] [li [] [text content]] 
      newsList = map toNews news
  in
  div [id "newsletters", class "submenu entry"]
      [ h3 [] [text "Inscrivez vous:"]
      , ul [] newsList
      ]

renderMisc misc =
  let toLink (content,address) =
        a [href address] [li [] [text content]] 
      linkList = map toLink misc
  in
  div [id "misc", class "submenu entry"]
      [ h3 [] [text "Divers:"]
      , ul [] linkList
      ]

renderSubMenu address title entries =
  let toA e = a [id e, onClick address (Entry e), href "#top"] [text e]
      linkList = map toA entries 
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

renderCounter = 
  div [ id "counter"]
      [ p [ align "center"]
          [ script "http://www.123compteur.com/counterskinable01.php?votre_id=678591" ""
          ]
      ]       


renderPlugins =
  div [ id "plugins", class "submenu"]
      [ ul []
           (map (\p -> li [] [p]) [renderMeteo])
      ]
view : Signal.Address Action -> Model -> Html
view address model =
  div [id "container"]
      [ renderMainMenu address (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            div [class "sideMenu"]
                [ renderPlugins
                , renderNewsLetter (.newsletters model)
                , renderMisc (.misc model)
                ]
            , pageFooter 
            ]
      ]

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }


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

-- Data
initialContent = 
  div [ class "subContainerData", id "index"]
      [ renderNewsList "Actualités de la commune" news
      , renderNewsList "La mairie vous informe" newsMairie
      ]

news : List News
news = 
  [{ emptyNews |
     title = "L'Auvergne dans le Best of de Lonely Planet"
   , date  = Date.fromString "10/29/2015"
   , descr = div [class "newsContent"]
                 [p [] [text "L'Auvergne fait une entrée remarquée dans le Best
                              of du voyage de Lonely Planet en 2016.
                              En 6ème position du classement des régions
                              à visiter dans le monde"]
                 , br [] []
                 , link "Source" "http://www.lonelyplanet.fr/article/lauvergne-6eme-region-du-monde-visiter-en-2016"
                 ]
   , pic   = Just "lonely.png"            
   }
  ,{ emptyNews |
     title = "Chant de Noël à l'église de Beaune le Froid"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsContent"]
                 [p [] [ text " Samedi 19 à 15h à l'église de Beaune le Froid, chant de Noël
                                 avec l'ensemble instrumental de la vallée verte et la
                                 chorale de Murol"]
                 ]
   }
  ,{ emptyNews |
     title = "Noël des enfants à la salle des fêtes de Murol"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsContent"]
                 [p [] [ text "Dimanche 20 à 14h, Noël des enfants à la salle des fêtes de Murol.
                                Une collecte  de denrée alimentaire sera réalisé à cette occasion
                                au profit de la banque alimentaire."]
                 ]
   }
  ,{ emptyNews |
     title = "Animations de Noêl "
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsContent"]
                 [p [] [text "Lundi 21 toute la journée, rue G. Sand,
                              animations de Noêl organisées par les commerçants."]]
   }
  ,{ emptyNews |
     title = "Chasse au trésor de Noël"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsContent"]
                 [p [] [text "Lundi 21 à 15h, chasse au trésor de Noël."]]
   }
  ,{ emptyNews |
     title = "3 contes de Noël"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsContent"]
                 [ p [] [text "Pour Noël : 3 contes de Noël."]
                 , br [] []
                 , link "lien" "" 
                 ]
   }                
  ]

newsMairie : List News
newsMairie =
  [{ emptyNews |
     title = "Nouveaux Horaires Navette"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsMairieContent"]
                 [ p  [] [text "les nouveaux horaires de la Navette Chambon/Lac - Murol - Saint Nectaire ---- Clermont Ferrand"]
                 , br [] []
                 , link "Télécharger les horaires" ""
                 , br [] []
                 , link "Dépliant ligne 74 navette" ""  
                 ]
   }
   ,
   { emptyNews |
     title = "Application vols/cambriolage"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsMairieContent"]
                 [ p  [] [text "Une application a été créée par les gendarmes 
                                pour faire l'inventaire de biens en cas de vols
                                 ou de cambriolages: \" Cambrio-Liste \"."]
                 , br [] []
                 , link "lien Apple-Store" ""
                 , br [] []
                 , link "lien Google Play" "" 
                 ]
   }
   ,
   { emptyNews |
     title = "Permanence mission locale pour l'emploi"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsMairieContent"]
                 [ p  [] [text "1er lundi de chaque mois permanence mission locale pour l'emploi."]
                 ]
   }
   ,
   { emptyNews |
     title = "Vente de terrain communaux"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsMairieContent"]
                 [link "Contactez la mairie" "" 
                 ]
   }
   ,
   { emptyNews |
     title = "Simplification du système administratif français"
   , date  = Date.fromString "12/15/2015"
   , descr = div [class "newsMairieContent"]
                 [ p [] [text "Le système administratif français nécessite une
                               simplification. Un site a été créé afin de recueillir
                               des suggestions d'amélioration dans les
                                démarches administratives. En savoir plus sur "]
                 , link "http://www.faire-simple.gouv.fr/" "http://www.faire-simple.gouv.fr/" 
                 ]
   }
  ]

newsletters =
  [("aux bulletins d'informations de la commune"
   ,"https://docs.google.com/forms/d/1sAJ3usxihhBxeY6SNyr2v3JI98Ii27QL-7N_Yjtw4v8/viewform"
   )
   ,
   ("aux commissions"
   ,"https://docs.google.com/forms/d/1RzrxYsue2UqQn2VBdPK3AamNAUb1IyejhWfENwjynkA/viewform"
   )
   ,
   ("recevoir une alerte mise à jour site"
   ,"https://docs.google.com/forms/d/1sAJ3usxihhBxeY6SNyr2v3JI98Ii27QL-7N_Yjtw4v8/viewform"
   )
  ]

misc = 
  [("Visiter le musée des peintres de Murol","http://www.musee-murol.fr/fr")] 



