module Murol where


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char

-- Model

type alias Model = 
  { mainMenu    : Menu
  , logos       : List  String
  , news        : List (String,String)
  , newsletters : List (String,String)
  , misc        : List (String,String)
  }

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
         , Leaf "Horaires" ""
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

news = [("http://www.lonelyplanet.fr/article/lauvergne-6eme-region-du-monde-visiter-en-2016"
        ,"L'Auvergne fait une entrée remarquée dans le Best of du voyage de Lonely Planet en 2016. En 6ème position du classement des régions à visiter dans le monde."
        )]

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




initialModel = 
  { mainMenu    = mainMenu
  , logos       = logos
  , news        = news
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
         [p [] [ text "Vous souhaitez passer une information"
               , a [href ""] [text " contactez le webmaster"]
               ]
         ] 


 
renderListImg pics =
  div [id "pics"]
      [ ul []
           (map (\e -> li [] [img [src ("/images/" ++ e)] []]) pics)]


renderNews news =
  let toNews (address,content) =
        a [href address] [li [] [text content]] 
      newsList = map toNews news
  in
  div [id "news", class "submenu entry"]
      [ h3 [] [text "La mairie vous informe"]
      , ul [] newsList
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
      , div [id "middleDiv"]
            [ renderNews (.news model)
            , renderNewsLetter (.newsletters model)
            , renderMisc (.misc model)
            ] 
      , renderListImg (.logos model)
      
      , renderPlugins
      , pageFooter
      ]

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }


-- Utils

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
         , a [href s] [text s]
         ]

site tex addr =
 span [] [ text "Site: "
         , a [href addr] [text tex]
         ]

link tex addr = a [href addr] [text tex]



 



