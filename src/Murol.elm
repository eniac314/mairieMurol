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
import Time exposing (..)
import Gallery exposing (initMiniGallery
                        , updateM
                        , viewM
                        , Action
                        , MiniGallery
                        )
import Utils exposing ( Menu
                      , Submenu
                      ,  renderMainMenu
                      , renderSubMenu
                      , renderListImg
                      , link
                      , script
                      , mail
                      , nullTag
                      , year'
                      , months'
                      , day'
                      , capitalize
                      , mainMenu
                      , logos
                      , pageFooter)
import Date exposing (..)

-- Model

type alias Model = 
  { mainMenu    : Menu
  , logos       : List (String,String)
  , newsletters : List (String,String)
  , news        : List News
  , miniGallery : Gallery.MiniGallery
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


--type alias Submenu =
--  { current : String 
--  , entries : List String
--  }  
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





initialModel = 
  { mainMenu    = mainMenu
  , logos       = logos
  , newsletters = newsletters
  , news        = prepNews today news
  , miniGallery = fst (initMiniGallery time)
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
  --| UtilsEntry (Utils.Action)
  | Drop  Int
  | GalleryAction Gallery.Action
  --| ScrollY Int


update action model =
  case action of 
    NoOp    -> (model, none)
    Hover s -> (model, none)
    --UtilsEntry e -> (model, none)
    --ScrollY r -> (model, none)
    Drop id -> 
      let n1 = List.map (dropN id) (.news model)
      in ({ model | news = n1 }, none)
    GalleryAction act -> 
      let (newGallery, effects) = Gallery.updateM act (.miniGallery model)
      in ({model | miniGallery = newGallery} , Effects.map GalleryAction  effects)


--update : Action -> Model -> (Model, Effects Action)
--update action model =
--  case action of 
--    NoOp -> (model,none)
--    (GalleryAction name act) ->
--      let updateWithId (g,folder) =
--            if (folder == name)
--            then (Gallery.update act g, folder)
--            else ((g,none),folder)

--          (ng,effs) = List.foldl (\((g,e),f) (gs,ef) ->
--                                   ((g,f)::gs,(Effects.map (GalleryAction f) e)::ef))
--                                 ([],[])
--                                 (List.map updateWithId (.galleries model))


--      in ({ model | galleries = List.reverse ng}
--          , Effects.batch effs)


-- View

renderContent n1 address = 
  div [ class "subContainerData", id "index"]
      [ renderSearch
      , renderNewsList address "Actualités de la commune" n1
      , renderListImg logos
      , renderMisc
      ]


renderNewsList : Signal.Address Action -> String -> List News -> Html
renderNewsList address title xs =
  div [class (title |> words |> List.map capitalize |> join "")]
      ([ h4 [] [text title]
       , p  [ id "lastUpdate" ]
            [text "Dernière mise à jour le mardi 25 septembre 2018"]
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

renderSearch = 
  div []
      [ h4 [] [text "RECHERCHER SUR LE SITE"]
      , iframe [ src "search.html"
               , id "searchIframe" 
             --, width 
               , height 46
               , attribute "frameborder" "0" --(Json.Encode.string "0")
               --, attribute "scrolling" "no"
               --, attribute "onload" "resizeIframe(this);"
               --, attribute "allowfullscreen" "true"--(Json.Encode.string "true")
            , style [ ("width", "100%")
                    --, ("height","100%")
                    --, ("overflow","hidden")
                    --, ("max_height","200px")
                    ]
            ]
            []
      ]

renderNewsLetter news =
  let toNews (content,address) =
        a [href address] [li [] [text content]] 
      newsList = List.map toNews news
  in
  div [id "newsletters", class "submenu entry"
      , style [("text-align", "center")]
      ]
      [ h3 [] [text "Visite virtuelle aerienne"]
      , div [ style [("width","300px")
                    ,("margin","auto")
                    ,("margin-top","0.5em")
                    ,("display","inline-block")
                    ,("background-color","darkgrey")
                    ,("text-align","center")
                    ]
            ]
            [ a [ style [("margin","auto")
                        ,("margin-top","0.5em")
                        ,("margin-bottom","0.5em")
                        ,("display","inline-block")
                        ,("cursor","pointer")
                        ]
                , href "visite/visite-virtuelle-aerienne-murol.html"
                , target "_blank"
                ]
                [ img [src "/images/visiteVirt.jpg"
                      , style [("border-style","solid")
                              ,("border-width","5px")
                              ,("border-color","white")
                              ,("box-shadow","5px 5px 5px black")
                              ]
                      ]
                      []

                ]
            , p [] 
                    [ text "Réalisée par la société "
                    , a [ href "http://www.w3ds.fr/"
                        , target "_blank"
                        , style [("color","teal")]
                        ]
                        [text "W3D's"]
                    ]
            ]
      ]
      --[ h3 [] [text "Inscrivez vous"]
      --, ul [] newsList
      --]

renderMisc =
  div [ id "misc", class "divers"]
      [ h4 [] [text "Divers"]
      , div [id "chateauDivers"]
            [ 
            --  text "Fermeture annuelle du "
            --, a [href "http://www.musee-murol.fr/fr", target "_blank" ]
            --    [ text " musée des peintres de l’Ecole de Murols"]
            --, p [] [text "Réouverture le 23 décembre."]
              p [] [ text "Le château de Murol est ouvert au public pour des visites libres et des visites animées." ] 
            , p [] [ text "Horaires, tarifs et autres renseignements sur le site officiel :"
                   , a [href "http://murolchateau.com/", target "_blank" ] [text "murolchateau.com"]
                   ]
            
            ]
      , div [id "peintres"]
            [ 
            --  text "Fermeture annuelle du "
            --, a [href "http://www.musee-murol.fr/fr", target "_blank" ]
            --    [ text " musée des peintres de l’Ecole de Murols"]
            --, p [] [text "Réouverture le 23 décembre."]
              text "A découvrir, " 
            , a [href "http://www.musee-murol.fr/fr", target "_blank" ]
              [ text "le musée des peintres de l’Ecole de Murols"]
            , p []
                [ text "Consultez la " 
                , a [ href "baseDocumentaire/plaquette musée Murol 2017.pdf"
                    , target "_blank"]
                    [text "plaquette du Musée"]]
            , p []
                [ text "Pour une visite en famille :"
                --, a [ href "baseDocumentaire/Carte jeu de piste 2016.pdf", target "_blank"]
                    --[ text "carte jeu de piste"]
                --, text " le "
                --, a [ href "baseDocumentaire/livret jeu musée 2017.pdf", target "_blank"]
                --    [ text "livret jeu"]
                , text " la "
                , a [ href "baseDocumentaire/Carte jeu de piste 2017.pdf", target "_blank"]
                    [ text "carte du jeu de piste"]
                , text " et le "
                , a [ href "baseDocumentaire/livret saison 2017.pdf"
                    , target "_blank"]
                    [text "livret jeu"]
                ]
            , p []
                []
            ]
      , div [id "horairesContact"]
            [h4 [] [text "Mairie pratique:"]
            , div [ id "horaires"]
                  [ h5 [] [text "Horaires d'ouverture"]
                  , p  [] [text "Du lundi au vendredi : 9h à 12h30 / 13h30 à 17h"]
                  , p  [] [text "Rendez-vous possibles avec le maire ou les adjoints le samedi matin"]
                  ]
            , div [ id "contact"]
                  [ h5 [] [text "Contact"]
                  , p  [] [text "Mairie de Murol - Place de l'hôtel de ville - 63790 Murol"]
                  , p  [] [text "Tel: 04 73 88 60 67 / Fax : 04 73 88 65 03 "]
                  , mail "mairie.murol@wanadoo.fr" 
                  ]
            ] 
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



renderPlugins =
  div [ id "plugins", class "submenu"]
      [ h3 [] [text "Pratique"]
      , ul []
           (List.map (\p -> li [] [p]) [renderMeteo, renderEtatRoutes])
      , a [href "NumerosD'urgences.html", id "urgencesLink"]
          [text "Numéros d'urgences"]
      ]

renderAgenda = 
  div [id "agenda", class "submenu"]
      [ h3 [] [text "Agenda"]
      , iframe [ src "https://calendar.google.com/calendar/embed?showTitle=0&showTabs=0&showNav=0&showPrint=0&showCalendars=0&showTz=0&mode=AGENDA&height=150&wkst=2&hl=fr&bgcolor=%23FFFFFF&src=1claq68scg7llpg29j2fasprtk%40group.calendar.google.com&;color=%23fe3b00&;src=n1jce3hgvarkt6n3o69c6nl66g%40group.calendar.google.com&;color=%23007451&;src=r46rbonnui234n2b2glau5btoo%40group.calendar.google.com&;color=%2305f2ff&ctz=Europe%2FParis"
               ] []
      , p [] [a [href "/Animation.html"]
                [text "Consulter le calendrier"]
             ]
      , p [] [a [href "/Animation.html"] [text "Programmes des manifestations"]]
      ] 
      
renderMiniGallery address model = 
  div [id "minGalDiv", class "submenu"]
      [ h3 [] [text "Coup d'oeil sur la photothèque"]
      , div [style [("width","100%")
                   ,("margin-top","0")
                   ,("text-align","center")
                   --,("background-color","blue")
                   ]
            ]
            [ div [ style [("display","inline-block")
                          ,("margin-top","0")
                          ,("margin","auto")
                          ,("text-align","left")
                          --,("background-color","red")
                          --,("padding","-1em")
                          ]
                  ]
                  [Gallery.viewM (Signal.forwardTo address GalleryAction) (.miniGallery model)
                  ]
                  ]   
      ]

view : Signal.Address Action -> Model -> Html
view address model =
  div [id "container"]
      [ renderMainMenu ["Accueil"] (.mainMenu model) 
      , div [ id "subContainer"]
            [ renderContent (.news model) address
            , div [class "sidebar"]
                  [ renderAgenda
                  , renderMiniGallery address model
                  , renderPlugins
                  , renderNewsLetter (.newsletters model)
                  ]
            ]
      , pageFooter 
      ]

timer = Signal.map (\_ -> GalleryAction Gallery.TimeStep) (every (6*Time.second))

app =
    StartApp.start
          { init = (initialModel, none)
          , view = view
          , update = update
          , inputs = [timer, focusUpdate]
          }

main =
    app.html

port today : String

port time : Int

port focus : Signal Bool

--focusUpdate : Signal GalleryAction
focusUpdate = Signal.map (\b -> GalleryAction (Gallery.Focused b)) focus

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks



-- Data
 
news : List News
news = 
  [
  --{ emptyNews |
  --   title = "L'Auvergne dans le Best of de Lonely Planet"
  -- , date  = Date.fromString "10/29/2015"
  -- , descr = div [class "newsdescr"]
  --               [p [] [text "L'Auvergne fait une entrée remarquée dans le Best
  --                            of du voyage de Lonely Planet en 2016.
  --                            En 6ème position du classement des régions
  --                            à visiter dans le monde: "
  --               , link "Source" "http://www.lonelyplanet.fr/article/lauvergne-6eme-region-du-monde-visiter-en-2016"]
  --               ]
  -- , pic   = Just "lonely.png"            
  -- }
  { emptyNews |
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
   ,{ emptyNews |
     title = "Le diaporama 2015 est disponible"
   , date  = Date.fromString "01/01/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [ text "Le diaporama de la commune pour l'année 2015 est disponible."]
                 , a [ target "_blank", href "/baseDocumentaire/DIAPORAMA MUROL 2015.pdf"]
                     [ text "Télécharger"]
                 ]
   , expiry = Date.fromString "04/02/2016"
   } 
   ,{ emptyNews |
     title = "Le bulletin municipal n°7 est disponible"
   , date  = Date.fromString "03/01/2016"
   , descr = div [class "newsdescr"]
                 [ a [ href "/BulletinsMunicipaux.html"]
                     [ text "lien"]
                 ]
   , expiry = Date.fromString "09/11/2016"
   }
   ,{ emptyNews |
     title = "SOS Animaux - Campagne de stérilisation des chats"
   , date  = Date.fromString "03/11/2016"
   , descr = div [class "newsdescr"]
                 [ p  [] [text "SOS Animaux organise une campagne de
                               stérilisation des chats (males et femelles)."]
                 , p  [] [text "Les vétérinaires d'Issoire, de Brassac les Mines et 
                               de St Germain Lambron sont partenaires de cette 
                               campagne. "]
                 , p  []
                      [text "Plus d'infos "
                      ,a [href "/Animaux.html"] [text "page Animaux"]
                      ]
                  ]
   , expiry = Date.fromString "04/16/2016"
   } 
   ,{ emptyNews |
     title = "Coupure d'électricité"
   , date  = Date.fromString "03/11/2016"
   , descr = div [class "newsdescr"]
                 [p [] [text "ERDF procèdera à une coupure d'électricité
                               le mercredi 16 mars de 9h30 à 12h00 
                               sur le secteur de la rue d'Estaing, G. 
                               Sand, place du pont, le bourg, Rue Chauderon, 
                               du prélong, du levat, du château et route 
                               de St Nectaire.  "]
                 ]
   , expiry = Date.fromString "03/17/2016"
   } 
   --,{ emptyNews |
   --  title = "Chaîne des Puys & Faille de Limagne - nouveau film"
   --, date  = Date.fromString "03/11/2016"
   --, descr = div [class "newsdescr"]
   --              [ p [] [text "Découvrez, les Origines de la Terre, le "
   --                     , a [ href "https://www.youtube.com/watch?v=nkWlN3u2evc"
   --                         , target "_blank"]
   --                         [text "nouveau film"]
   --                     , text " promotionnel de la candidature au patrimoine mondial 
   --                            pour la Chaîne des Puys et la faille 
   --                            de Limagne. "
   --                     ]
   --              ]
   --, expiry = Date.fromString ""
   --} 
   --,{ emptyNews |
   --  title = "Survol du château de Murol en drone - Vidéo"
   --, date  = Date.fromString "03/11/2016"
   --, descr = div [class "newsdescr"]
   --              [ p [] [text "Film réalisé par Andrzej W Szczygiel (entreprise PROP-EYE LTD)"]
   --              , p [] [a [href "https://youtu.be/tY89AZLnvZc", target "_blank"]
   --                        [text "voir la vidéo"]
   --                     ] 
   --              ]
   --, expiry = Date.fromString ""
   --} 
   ,{ emptyNews |
     title = "Bienvenue sur le nouveau site officiel de la commune de Murol!"
   , date  = Date.fromString "03/12/2016"
   , descr = div [class "newsdescr"]
                 [ p [style [("margin-right","15%")]]
                     [text "Nous l’avons mis en ligne dans sa version 
                               « printemps », il évoluera au fil des 
                               saisons… "]
                 , p [style [("margin-right","15%")]]
                     [text "Découvrez ses nouvelles fonctionnalités et ses nombreux liens."]
                 , p [style [("margin-right","15%")]]
                     [text "Les listes (hébergements, commerces, artistes, associations…) ne sont 
                               pas exhaustives ! Nous les avons réalisées avec 
                               les informations que nous avons à ce jour. "]
                 , p [style [("margin-right","15%")]]
                     [text "N’hésitez pas à contacter le webmaster en cliquant 
                               sur le lien en bas de page, pour 
                               toute erreur ou oubli ! "]
                 , p [ style [("float","right"), ("margin-right","30%")]]
                     [b [] [text "La commission communication "]]
                 ]
   , expiry = Date.fromString "04/12/2016"
   }
   ,{ emptyNews |
     title = "Fermeture exceptionnelle de la poste"
   , date  = Date.fromString "03/16/2016"
   , descr = div [class "newsdescr"]
                 [p [] [text "La poste de Murol sera exceptionnellement fermée
                              les après-midis du 16 mars au 18 mars inclus."]]
   , expiry = Date.fromString "03/19/2016"
   }
   ,{ emptyNews |
     title = "Le programme du centre de loisirs d'avril est disponible!"
   , date  = Date.fromString "03/17/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [ text "Le centre de loisirs du SIVOM de la Vallée Verte ouvre
                             ses portes du 11 au 22 avril pour les enfants de 3 à 11 ans.
                             Les plaquettes d'information seront prochainement
                             dans les cartables des enfants et dans les mairies.
                             Vous pouvez déjà consulter "
                     , a [ href "/baseDocumentaire/periscolaire/planning activités avril.pdf", target "_blank"]
                         [ text "le programme des activités prévues"]
                     ]
                 ]
   , expiry = Date.fromString "04/23/2016"
   }                  
  ,{ emptyNews |
     title = "Des offres d'emplois saisonniers sont disponibles !"
   , date  = Date.fromString "03/21/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Le forum pour les emplois saisonniers se
                               tiendra mercredi 7 avril 2016 à la salle
                               polyvalente de Besse de 14h à 17h."]
                 , p [] [text "Le détail des offres est accessible sur la page "
                        ,a [href "/OffresD'emploi.html"] [text "offres emploi"]
                        ] 
                 ]
   , expiry = Date.fromString "05/14/2016"
   }
   ,{ emptyNews |
     title = "Artistes et artisans d'Art, inscrivez-vous au Festival d'Art de Murol!"
   , date  = Date.fromString "04/12/2016"
   , descr = div [class "newsdescr"]
                 [p [] [text "Le Festival d'Art aura lieu dans les rues de Murol le dimanche 31
                             juillet 2016. Pour participer, renvoyez la "
                        , a [href "/baseDocumentaire/FA2016.pdf", target "_blank"]
                            [text "fiche d'inscription"]
                        , text " complétée à la mairie de Murol avant le 30 juin 2016"
                       ]
                 ]
   , expiry = Date.fromString "07/01/2016"
   }
   ,{ emptyNews |
     title = "Murol Infos 29"
   , date  = Date.fromString "04/24/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" (Avril 2016) est disponible: "
                    , a [href "baseDocumentaire/murolInfo/29.pdf"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "05/24/2016"
   }
   ,{ emptyNews |
     title = "Les Médiévales de Murol approchent..."
   , date  = Date.fromString "04/24/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Les 10eme Médiévales de Murol se dérouleront VENDREDI 6 & SAMEDI 7 MAI 2016"]
                 , a [href "http://www.medievalesmurol.fr/", target "_blank"] [text "Site officiel"]
                 ]
   , expiry = Date.fromString "05/08/2016"
   } 
  ,{ emptyNews |
     title = "Photos des Médiévales 2016"
   , date  = Date.fromString "05/16/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Des photos des Médiévales 2016 sont disponibles dans la photothèque.
                               Si vous avez des photos que vous souhaitez partager, contactez le webmaster."]
                 , a [href "/Medievales.html"] [text "Lien photothèque"]
                 ]
   , expiry = Date.fromString "06/15/2016"
   }
   ,{ emptyNews |
     title = "Vernissage d'\"Horizons Arts-Nature en Sancy\""
   , date  = Date.fromString "05/16/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "La journée de vernissage d'\"Horizons Arts-Nature en Sancy\"
                               aura lieu le jeudi 16 juin 2016, elle est ouverte au public.
                               Les inscriptions auront lieu du 11 au 23 mai."
                        ]
                 , a [href "baseDocumentaire/AFFICHE2016.pdf" , target "_blank"] [text "Affiche 2016"]
                 , br [] []
                 , a [href " http://www.horizons-sancy.com/", target "_blank"] [text "Site officiel"]
                 ]
   , expiry = Date.fromString "06/17/2016"
   } 
   ,{ emptyNews |
     title = "Réunion publique sur la réhabilitation de la zone humide de Murol"
   , date  = Date.fromString "05/16/2016"
   , descr = div [class "newsdescr"]
                 [p [] [text "Afin d'illustrer la réunion publique sur la réhabilitation de la zone humide de Murol de
                              mardi 16 mai, vous trouverez dans la documentation: "
                        , a [href "baseDocumentaire/Note de présentation SIVU et contrat terrirorial.pdf", target "blank"]
                            [text "une note de présentation"]       
                        , text " du SIVU et du contrat territorial ainsi que "
                        , a [href "baseDocumentaire/Dossier zone humide de Murol.pdf", target "blank"]
                            [text "le dossier sur la zone humide de Murol"
                        , text "."]
                        ]
                 ]
   , expiry = Date.fromString "05/20/2016"
   }
   ,{ emptyNews |
     title = "Murol obtient le label Pavillon Bleu"
   , date  = Date.fromString "05/21/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "La commune de Murol ainsi que celle de
                               Chambon sur Lac ont reçu officiellement
                               mercredi 18 mai le label Pavillon Bleu 2016
                               à Villeneuve les Maguelone (34) pour leurs plages au lac Chambon.
                               Ce label international récompense les
                               communes qui veillent à la qualité de
                               leurs eaux de baignade mais aussi qui
                               s'inscrivent dans une démarche globale
                               de respect de l'environnement."]
                 , a [href "http://www.pavillonbleu.org/", target "_blank"]
                     [text "www.pavillonbleu.org"]
                 , br [] []
                 , a [href "/Annee2016.html"]
                     [text "Lien photothèque"] 
                 ]
   , expiry = Date.fromString "06/21/2016"
   , pic = Just "PAVILLON BLEU LOGO 2.png"
   }
   ,{ emptyNews |
     title = "Journée des Murolais"
   , date  = Date.fromString "05/25/2016"
   , descr = div [class "newsdescr"]
                 [p [] [text "La journée des Murolais aura
                              lieu samedi 28 mai au château, venez nombreux!"
                        ]
                 , a [href "baseDocumentaire/affiche journee des murolais 2016.pdf", target "_blank"] [text "Affiche 2016"]]
   , expiry = Date.fromString "05/29/2016"
   }
   ,{ emptyNews |
     title = "Mise à jour photothèque"
   , date  = Date.fromString "06/02/2016"
   , descr = div [class "newsdescr"]
                 [p [] [ text "Des photos du " 
                       , a [href "Annee2016.html"] [text "Mouv'Auvergnat"]
                       , text ", du "
                       , a [href "Annee2016.html"] [text "vernissage"]
                       , text " de l'exposition temporaire du musée et de la "
                       , a [href "JourneeMurolais.html"] [text "journée des Murolais 2016"]
                       , text " sont disponibles dans la photothèque."] 
                 ]
   , expiry = Date.fromString "06/17/2016"
   }
   ,{ emptyNews |
     title = "Sébastien Gouttebel dans l'émission \"Folie Passagère\""
   , date  = Date.fromString "06/02/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [ a [target "_blank", href "https://www.youtube.com/watch?v=htFqQhwmGLE"]
                            [text "Vidéo"]
                        , text "  du passage de Sébastien Gouttebel dans
                                l'émission \"Folie Passagère\" sur les actions
                                en milieu rural"
                        ]
                 ]
   , expiry = Date.fromString "06/17/2016"
   }
   ,{ emptyNews |
     title = "Fête de la musique"
   , date  = Date.fromString "06/09/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Cette année, grâce à l'association 
                               \"les pirates\", Murol fêtera la musique.
                               Venez nombreux au concert sur la place de
                               l'église le samedi 18 juin!"
                        ]
                 , a [ href "baseDocumentaire/affiche fête de la musique 2016.pdf"
                     , target "_blank"]
                     [text "Affiche du concert"]

                 ]
   , expiry = Date.fromString "06/19/2016"
   }
  ,{ emptyNews |
     title = "Murol Infos 30"
   , date  = Date.fromString "06/09/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" (Juin 2016) est disponible: "
                    , a [href "baseDocumentaire/murolInfo/30.pdf", target "_blank"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "06/19/2016"
   }
   ,{ emptyNews |
     title = "Centre de loisirs - été 2016"
   , date  = Date.fromString "06/09/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [text "Centre de loisirs pour les 3 à 11 ans:
                            retrouvez les programmes d'activités de
                            cet été ainsi que le dossier d'inscription
                            dans l'onglet vie locale/ péri et extrascolaire/CLSH"]
                 ]
   , expiry = Date.fromString "09/01/2016"
   }
   ,{ emptyNews |
     title = "Video du mouv'auvergnat"
   , date  = Date.fromString "06/09/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [text "Une vidéo du Mouv'Auvergnat qui a regroupé
                            un millier de lycéens au lac Chambon est disponible :"]
                 , a [href "https://www.youtube.com/watch?v=afkBKX-iZtE", target "_blank"] [text "lien youtube"]
                 ]
   , expiry = Date.fromString "06/19/2016"
   }
  ,{ emptyNews |
     title = "Animation saison estivale - programmes disponibles"
   , date  = Date.fromString "06/20/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [ text "La saison estivale arrive avec de nombreuses animations présentées sur des programmes par quinzaine.
                             Retrouvez également le détail de la journée du 14 juillet"]
                 , a [href "/baseDocumentaire/animation/programme1.pdf", target "_blank"]
                     [text "programme 4-16 juillet"]
                 , br [] []
                 , a [href "/baseDocumentaire/animation/programme2.pdf", target "_blank"]
                     [text "programme 17-31 juillet"]
                 , br [] []
                 , a [href "/baseDocumentaire/animation/affiche14juillet2016.pdf", target "_blank"]
                     [text "programme 14 juillet"]
                 ]
   , expiry = Date.fromString "07/31/2016"
   }
   ,{ emptyNews |
     title = "Murol Infos 31"
   , date  = Date.fromString "06/20/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" (saison estivale, 14 juillet, réunion publique PLU...)
                            ainsi que ses annexes sont disponibles: "]
                    , a [href "baseDocumentaire/murolInfo/31.pdf", target "_blank"] [text "Murol infos 31"]
                    , br [] []
                    , a [href "baseDocumentaire/ficheORGANICITE.pdf", target "_blank"] [text "fiche ORGANICITE"]
                    , p []
                        [text "programmes des animations juillet 2016:"
                        , br [] []
                        , a [href "/baseDocumentaire/animation/programme1.pdf", target "_blank"]
                            [text "programme 4-16 juillet"]
                        , br [] []
                        , a [href "/baseDocumentaire/animation/programme2.pdf", target "_blank"]
                            [text "programme 17-31 juillet"]
                        , br [] []
                        , a [href "/baseDocumentaire/animation/affiche14juillet2016.pdf", target "_blank"]
                            [text "programme 14 juillet"]
                        ]
                 ]
   , expiry = Date.fromString "07/20/2016"
   }
  ,{ emptyNews |
     title = "Photos fête des écoles et des TAP"
   , date  = Date.fromString "06/20/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les photos de la fête des écoles et des TAP qui a eu
                           lieu le 11 juin 2016 sont disponibles dans la "
                    , a [href "Annee2016.html"] [text "photothèque"]
                    ]
                 ]
   , expiry = Date.fromString "07/01/2016"
   }
  ,{ emptyNews |
     title = "Nouveautés dans les commerces de Murol"
   , date  = Date.fromString "06/20/2016"
   , descr = div [class "newsdescr"]
                 [ p [] 
                     [text "La boucherie a rouvert ses portes depuis le 1er juin 2016.
                            Monsieur Papon, qui a repris ce commerce, vous propose ses "
                     , a [href "/baseDocumentaire/commerces/flyerBoucherie.pdf", target "_blank"] [text "spécialités"]
                     , text "."
                     ]
                 , p []
                     [ text "Le supermarché SPAR offre de nouveaux services à ses clients, le drive et la livraison à domicile,
                             à retrouver sur le site du "
                     , a [href "/Commerces.html#SupermarchéSPAR"] [text "magasin"]
                     , text "."
                     ]
                 ]
   , expiry = Date.fromString "07/20/2016"
   }
  
  ,{ emptyNews |
     title = "COUPURE DE COURANT POUR TRAVAUX"
   , date  = Date.fromString "06/29/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "JEUDI 30 JUIN de 9h à 12h
                          Rue de la Pardaniche
                          Place de la Mairie
                          Rue Chabrol
                          Groire"
                    ]
                 , p []
                     [text "JEUDI 30 JUIN de 12h à 15h
                            Rue de la Pardaniche
                            Le Bourg
                            Rue Chabrol
                            Route de Groire
                            Rue Guy de Maupassant
                            Rue de Besse"]
                 ]
   , expiry = Date.fromString "07/01/2016"
   }
   ,{ emptyNews |
     title = "Livret d'informations sur le lac Chambon"
   , date  = Date.fromString "07/04/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Dans le cadre de la labellisation Pavillon Bleu de leurs plages,
                           les communes de Chambon sur Lac et de Murol ont réalisé un livret
                           d'informations sur le lac Chambon. "
                    , a [href "baseDocumentaire/livretLac.pdf", target "_blank"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "09/04/2016"
   }
   ,{ emptyNews |
     title = "Minute de silence en hommage des victimes de Nice"
   , date  = Date.fromString "07/17/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "A la demande de la préfecture, une minute de silence sera observée
                          dimanche 17 juillet à midi devant la mairie de Murol en hommage aux victimes de Nice."]
                 ]
   , expiry = Date.fromString "07/19/2016"
   }    
   ,{ emptyNews |
     title = "Animation saison estivale - programmes août disponibles"
   , date  = Date.fromString "07/31/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [ text "La saison estivale continue avec de nombreuses animations présentées sur des programmes par quinzaine.
                             "]
                 , a [href "/baseDocumentaire/animation/programme3.pdf", target "_blank"]
                     [text "programme 31 juillet - 12 août"]
                 , br [] []
                 , a [href "/baseDocumentaire/animation/programme4.pdf", target "_blank"]
                     [text "programme 14 - 31 août"]
                 
                 ]
   , expiry = Date.fromString "08/31/2016"
   }
  ,{ emptyNews |
     title = "Informations rentrée"
   , date  = Date.fromString "09/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le nouveau "
                    , a [href "/VieScolaire.html"] [text "calendrier scolaire"]
                    , text " et les "
                    , a [href "/PériEtExtra-scolaire.html"] [text "documents d'inscription"]
                    , text " aux services périscolaires sont disponibles."
                    ]
                 ]
   , expiry = Date.fromString "10/14/2016"
   } 
   ,{ emptyNews |
     title = "Semaine de la parentalité - 3 au 8 octobre"
   , date  = Date.fromString "10/01/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La CAF du Puy-de-Dôme organise la première semaine de la parentalité
                          \"Etre parents d'ado\" du 3 au 8 octobre 2016. "]
                 , p [] [ text "Consultez "
                        , a [href "baseDocumentaire/plaquette_semaineParentalite2016.pdf", target "_blank"]
                            [text "le programme"]]
                 ]
   , expiry = Date.fromString "10/15/2016"
   }
   ,{ emptyNews |
     title = "Conseil municipal"
   , date  = Date.fromString "10/10/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le prochain conseil municipal aura lieu mercredi
                           12 octobre à 20h30 à la mairie de Murol. L'ordre
                           du jour est consultable sur les panneaux d'affichage (mairie et Beaune)."]
                 ]
   , expiry = Date.fromString "10/13/2016"
   } 
   ,{ emptyNews |
     title = "Nouveautés pour le Pôle Lecture Publique du Sancy"
   , date  = Date.fromString "10/10/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le Pôle Lecture Publique du Sancy propose des 
                           animations mensuelles dans chacune des classes de la 
                           maternelle et de l'élémentaire. A la suite de 
                           ces interventions une permanence du bibliothécaire est assurée 
                           pour les adultes dans les locaux de l'office 
                           du tourisme de Murol de 15h30 à 16h30. 
                           Vous pourrez ainsi retourner vos livres, récupérer vos 
                           commandes, découvrir une sélection d'ouvrages (romans, polars...) et 
                           pourquoi pas adhérer si ce n'est pas déjà 
                           fait. Première permanence le jeudi 13 octobre 2016. 
                           Venez nombreux!"
                    ]
                 , p [] [ a [href "http://besse.agate-sigb.com/rechercher/info_bib.php"
                            , target "_blank"]
                            [text "Site du pôle lecture"]]
                 ]
   , expiry = Date.fromString "10/31/2016"
   }
   
   ,{ emptyNews |
     title = "Elections 2017"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "En 2017, auront lieu les élections présidentielles et 
                           législatives. 
                           Attention!                            
                           Pour pouvoir voter vous devez être inscrits sur 
                           les listes électorales. Si ce n’est pas le 
                           cas, vous devez vous inscrire impérativement avant le 
                           31 décembre 2016, après il sera trop tard! 
                           "]
                 ]
   , expiry = Date.fromString "12/31/2016"
   }
   ,{ emptyNews |
     title = "Festivités de Noël"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les fêtes se préparent à Murol, marché de Noël de l'APE,
                          passage du père Noël de la commune, fête des illuminations des
                          commerçants..."]
                 , p [] [text "Détails dans le "
                        , a [href "baseDocumentaire/murolInfo/32.pdf", target "_blank"]
                            [text "Murol Infos"]]
                 ]
   , expiry = Date.fromString "12/23/2016"
   } 
   ,{ emptyNews |
     title = "Opération 1001 petits déjeuners - 21 novembre"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les élèves des écoles élémentaires de Murol et de
                          Chambon sur lac bénéficieront d'une intervention 
                          de l'association Trisomie 21 du Puy de Dôme
                          sur le handicap. Elle sera suivie de la distribution de petits
                          déjeuners. Cette opération, au profit de l'association, est financée
                          par les collectivités de Murol et Chambon."]
                 , a [href "http://trisomie21-france.org/les-associations-regionales-et-departementales/les-associations-trisomie-21-pres-de-chez-vous/383-63-trisomie-21-puy-de-dome", target "_blank"]
                     [text "Site de l'association"]
                 ]
   , expiry = Date.fromString "11/22/2016"
   }
   ,{ emptyNews |
     title = "Pôle lecture publique 17 novembre"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La prochaine permanence du bibliothécaire pour les adultes
                          aura lieu le 17 novembre de 15h30 à 16h30 dans les locaux 
                          de l'office du tourisme de Murol."]
                 ,p [] [text "Vous  pouvez  ainsi  retourner  vos  livres,
                          récupérer  vos  commandes, découvrir  une  sélection  
                          d'ouvrages (romans, polars...) et pourquoi pas adhérer
                          si ce n'est pas déjà fait?
                          Venez nombreux!"]
                  , p [] [text "Dates des permanences suivantes: 
                          15 décembre, 12 janvier, 9 février, 30 mars, 11 mai et 22 juin. "
                      ]
                 ]
   , expiry = Date.fromString "11/18/2016"
   }
   ,{ emptyNews |
     title = "Changement de délégataire au château de Murol"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le conseil municipal du 7 novembre 2016 a attribué la nouvelle 
                          délégation de service public pour le château à la société Kléber Rossillon
                          qui succédera à la société Organicom à partir du 1er décembre 2016 
                          pour une durée de 12 ans."]
                 ]
   , expiry = Date.fromString "12/31/2016"
   } 
   ,{ emptyNews |
     title = "Murol Infos 32"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" (novembre 2016) est disponible: "
                    , a [href "baseDocumentaire/murolInfo/32.pdf", target "_blank"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "12/14/2016"
   }
   ,{ emptyNews |
     title = "Nouvel éclairage nocturne au chateau"
   , date  = Date.fromString "11/14/2016"
   , descr = div [class "newsdescr"]
                 [ p []
                     [text "le château de Murol et ses remparts sortent de l'ombre!
                            Découvrez les nouvelles photos HDR de l'éclairage nocturne."] 
                 , p []
                     [ text "Visitez "
                     , a [href "/PatrimoinePhoto.html"] [text "la photothèque"]
                     ]
                 ]
   , expiry = Date.fromString "11/31/2016"
   }
   ,{ emptyNews |
     title = "Service civique - missions à pourvoir en Auvergne"
   , date  = Date.fromString "12/12/2016"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Offres de services civiques sur la région
                           auvergne à pourvoir en 2017: "
                    , a [href "http://shoutout.wix.com/so/7LZaLlzW?cid=3aa2bccc-3c25-43d9-8912-f8d419f60ea8&region=b9a4e5c3-b1b0-4b29-9f0f-1c6df353a7b7#/main", target "_blank"]
                        [text "site de l'annonce"]
                    ]
                 ]
   , expiry = Date.fromString "01/12/2017"
   }
   ,{ emptyNews |
     title = "Noël des enfants 2016"
   , date  = Date.fromString "01/02/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "les photos du Noël des enfants de la
                           commune sont disponibles dans la "
                    , a [href "/Annee2016.html"] [text "photothèque"]
                    ]
                 ]
   , expiry = Date.fromString "02/02/2017"
   }
   ,{ emptyNews |
     title = "Les voeux du maire"
   , date  = Date.fromString "01/02/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le maire,Sébastien Gouttebel, et le conseil
                           municipal seront heureux de vous accueillir
                           le dimanche 22 janvier 2017 à la salle des
                           fêtes de Murol à 11h pour la présentation
                           du bilan de l’année écoulée et des
                           projets à venir."]
                 ]
   , expiry = Date.fromString "01/23/2017"
   }
   ,{ emptyNews |
     title = "Inscription pour le repas du CCAS"
   , date  = Date.fromString "01/02/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les réponses aux invitations pour le repas du CCAS
                           du 22 janvier,qu'elles soient positives ou négatives,
                           devront parvenir à la mairie au plus tard le 6 janvier
                           afin de faciliter l'organisation, merci!"]
                 ]
   , expiry = Date.fromString "01/07/2017"
   }
   ,{ emptyNews |
     title = "Nouveau programme d'activités du centre de loisirs"
   , date  = Date.fromString "01/15/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez le programme d'activité du centre
                          de loisirs pour les vacances de février"
                    ]
                 , a [href "/PériEtExtra-scolaire.html?bloc=3"] [text "lien"]
                 ]
   , expiry = Date.fromString "02/31/2017"
   }
   ,{ emptyNews |
     title = "Programme des activités périscolaires - mise à jour janvier/février"
   , date  = Date.fromString "01/15/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "A consulter "
                    , a [href "/PériEtExtra-scolaire.html?bloc=2"] [text "ici"]]
                 ]
   , expiry = Date.fromString "02/31/2017"
   }
   ,{ emptyNews |
     title = "Nouveautés dans la photothèque"
   , date  = Date.fromString "02/02/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Nouvelles photos disponibles: "
                    , a [href "/14Juillet.html"] [text "photos du dernier 14 juillet"]
                    , text ", "
                    , a [href "/baseDocumentaire/DIAPORAMA MUROL 2016.pdf", target "_blank"] [text "diaporama de l'année 2016"]
                    , text ", "
                    , a [href "/PatrimoinePhoto.html"] [text "diaporama sur le château"]
                    , text ", "
                    , a [href "/Annee2017.html"] [text "voeux du maire et repas du CCAS 2017"]
                    ]
                 ]
   , expiry = Date.fromString "02/31/2017"
   }
  ,{ emptyNews |
     title = "Changement de délégataire au château de Murol"
   , date  = Date.fromString "02/16/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Suite au conseil municipal du 1er février 2017, le maire, Sébastien Gouttebel, a signé la convention de
                           délégation de service public  pour le château mardi 14 février 2017 avec la société Kleber-Rossillon."
                    ]
                 , p []
                     [text "Le château ouvrira ses portes "
                     , b [] [text "tous les jours de 10h à 18h à partir de samedi 18 février 2017."]
                     ]
                 , p [] 
                     [ text "Retrouvez les informations sur le nouveau site du château: "
                     , a [href "http://murolchateau.com/", target "_blank"] [text "murolchateau.com"]
                     ]
                 ]
   , expiry = Date.fromString "03/16/2017"
   }
  ,{ emptyNews |
     title = "Le bulletin municipal n°8 est disponible"
   , date  = Date.fromString "03/14/2017"
   , descr = div [class "newsdescr"]
                 [ p [] [ text "Sommaire et téléchargement " 
                        , a [ href "/BulletinsMunicipaux.html"]
                            [ text "ici"]
                        ]
                 ]
   , expiry = Date.fromString "09/11/2017"
   }
   ,{ emptyNews |
     title = "Mise à jour page centre de loisirs - les vacances de printemps"
   , date  = Date.fromString "03/25/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les documents du centre de loisirs (programme, dossier d'inscription,
                           projet pédagogique et plaquette de présentation) ont étés mis à jour
                           pour les vacances de printemps."
                    ]
                 ,p [] 
                    [text "A consulter dans l'onglet vie locale/ péri et extrascolaire/CLSH"
                    ]   
                    
                 ]
   , expiry = Date.fromString "04/31/2017"
   }
   ,{ emptyNews |
     title = "Dispositif \"argent de poche\""
   , date  = Date.fromString "03/30/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Nouveau ! Le dispositif \"argent de poche\" sera opérationnel dès les vacances
                           de printemps. Vous êtes âgé de 14 à 18 ans et souhaitez participer à la vie
                           de la commune, en gagnant un peu d'argent de poche? Renseignez-vous en lisant
                           le "
                    , a [href "/baseDocumentaire/ados/Document d'information argent de poche.pdf", target "_blank"]
                        [text "document d'information"]
                    , text " et la "
                    , a [href "/baseDocumentaire/ados/plaquette printemps 2017 argent de poche.pdf", target "_blank"]
                        [text "plaquette printemps"]
                    , text " puis téléchargez le "
                    , a [href "/baseDocumentaire/ados/Dossier d'inscription argent de poche.pdf", target "_blank"]
                        [text "dossier d'inscription"]
                    , text " ! Vous pouvez aussi retrouver ces documents à la mairie."
                    ]
                 ]
   , expiry = Date.fromString "04/30/2017"
   }        
  ,{ emptyNews |
     title = "Formation professionnelle"
   , date  = Date.fromString "04/04/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Aux mois de mai et juin, le Crefad Auvergne vous
                           propose des animations et des journées de formation
                           pour les personnes qui ont des projets de création
                           de leur activité"
                    ]
                 , p []
                     [text "plus d'informations "
                     , a [href "/baseDocumentaire/Formation professionnelle.pdf"
                     , target "_blank"] [text "ici"]
                     ]
                 ]
   , expiry = Date.fromString "07/01/2017"
   }
   ,{ emptyNews |
     title = "Médiévales 2017 - le programme"
   , date  = Date.fromString "05/26/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les Médiévales 2017 auront lieu les 26 et 27 mai, venez nombreux!"]
                 , p []
                     [a [href "/baseDocumentaire/medievales.pdf"
                        , target "_blank"
                        ]
                        [text "affiche"]]
                 , h6 []
                      [text "Vendredi"]
                 , p []
                     [ b [] [text "11h"]
                     , text " inauguration et défilé des troupes"
                     ]
                 , p []
                     [ b [] [text "14h/19h"]
                     , text " jeux médiévaux et atelier apprenti chevalier "
                     ]
                 , p []
                     [ b [] [text "21h"]
                     , text " concert place de l’église"
                     ]
                 , h6 []
                      [text "Samedi"]
                 , p []
                     [ b [] [text "11h/19h"]
                     , text " jeux médiévaux, atelier apprenti chevalier,
                            combats médiévaux juniors"
                     ]
                 , p []
                     [ b [] [text "17h"]
                     , text " défilé des troupes "
                     ]
                 ]
   , expiry = Date.fromString "07/01/2017"
   }
   ,{ emptyNews |
     title = "Murol Infos 33"
   , date  = Date.fromString "05/11/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" présentant
                            les animations du printemps et le budget communal est disponible"
                    , a [href "baseDocumentaire/murolInfo/33.pdf", target "_blank"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "06/11/2017"
   }
   ,{ emptyNews |
     title = "Nouvelle activité sur la commune"
   , date  = Date.fromString "05/11/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [ a [href "http://western-poneys.wifeo.com/", target "_blank"]
                        [text "Western Poneys"]
                    , text " propose la location de poneys en main pour
                            enfants accompagnés d'un adulte (3 à 12 ans, max 30kg)"
                    ]
                 ]
   , expiry = Date.fromString "06/11/2017"
   }
   ,{ emptyNews |
     title = "Samedi 20 mai : journée des Murolais et Nuit des musées"
   , date  = Date.fromString "05/16/2017"
   , descr = div [class "newsdescr"]
                 [ h6 [] [text "La journée des Murolais"]
                 , p []
                     [text "La journée des murolais aura lieu le samedi 20 mai 2017
                            au château de Murol en présence du nouveau délégataire,
                            M. Kléber ROSSILLON et de la directrice Mme POIZOT. "
                     , b [] [text "Rendez-vous à 10h dans la haute cour."]]
                 , p [] 
                     [text "Le maire et le délégataire présenteront la stratégie de
                            développement de la nouvelle convention, puis vous pourrez
                            visiter le château et découvrir de nouveaux aménagements."]
                 , p [] [text "Pour la photo des murolais, le thème de cette année est
                               l’époque médiévale. Costumez-vous… si vous le souhaitez !"]
                 , p [] [text "La matinée se clôturera par un moment de convivialité."]
                 
                 , h6 [] [text "La nuit des musées"]
                 , p [] [ text "Le musée des peintres de l'Ecole de Murols propose, "
                        , b [] [text "samedi 20 mai de 21h00 à 23h00"]
                        , text ", une soirée insolite qui débutera par un concert
                                 classique et humoristique. Le quatuor des saxophonistes « " 
                        , b [] [text "Sancy-SaxSoFun "]
                        , text "» interprétera des œuvres nées de la rencontre du saxophone
                               et des grands compositeurs du 18 ème siècle, Bach, Haendel et Vivaldi."       
                        ]
                 , p [] [text "La soirée se poursuivra par la visite libre des œuvres des peintres dont
                               l'originalité réside dans la représentation des paysages de neige."] 
                 , p [] [text "Entrée gratuite dans la limite des places disponibles. "]
                 , p [] [ a [href "baseDocumentaire/affiche 20 mai.pdf"
                            , target "_blank"
                            ]
                            [text "lien affiche"]]
                 ]
   , expiry = Date.fromString "05/21/2017"
   }
   ,{ emptyNews |
     title = "La commune de Murol a obtenu le label Pavillon Bleu pour 2017"
   , date  = Date.fromString "05/19/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Suite aux décisions des jurys nationaux et internationaux, Murol a obtenu
                           le label pour la deuxième année consécutive. Plus d'informations dans le "
                    , a [href "/baseDocumentaire/PAVILLON BLEU dossier de presse 2017.pdf", target "_blank"] [text "dossier de presse Pavillon Bleu 2017"]
                    ]
                 ]
   , expiry = Date.fromString "09/15/2017"
   }
   ,{ emptyNews |
     title = "Inscription au Festival d'Art 30 juillet 2017"
   , date  = Date.fromString "05/26/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Artistes ou artisans d'art, professionnels ou amateurs, vous
                          pouvez vous inscrire au Festival d'Art jusqu'au 30 juin 2017."]
                 , p [] [ a [href "baseDocumentaire/FA2017.pdf"
                            , target "_blank"
                            ]
                            [text "lien fiche d'inscription"]
                        ]
                 ]
   , expiry = Date.fromString "07/02/2017"
   }
   ,{ emptyNews |
     title = "Offres d'emploi saisonniers au château de Murol"
   , date  = Date.fromString "05/26/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le château de Murol recrute pour l'été."]
                 , p []
                     [ text "Voir les "
                     , a [href "/OffresD'emploi.html"]
                         [text "offres"]
                     ]
                 ]
   , expiry = Date.fromString "06/25/2017"
   }
   ,{ emptyNews |
     title = "Photos de la journée des Murolais et de la Nuit des Musées"
   , date  = Date.fromString "05/26/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Retrouvez les photos des éditions 2017 de ces deux 
                            évènements dans la "]
                    , a [href "/Photothèque.html"]
                        [text "photothèque"]
                 ]
   , expiry = Date.fromString "06/15/2017"
   }
   ,{ emptyNews |
     title = "Offres d'emploi - agent technique remplaçant"
   , date  = Date.fromString "06/01/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La mairie de Murol recherche un agent technique remplaçant."]
                 , p []
                     [ text "Voir les "
                     , a [href "/OffresD'emploi.html"]
                         [text "offres"]
                     ]
                 ]
   , expiry = Date.fromString "06/25/2017"
   }
   ,{ emptyNews |
     title = "Photos du vernissage de l'exposition du musée et des Médiévales"
   , date  = Date.fromString "06/01/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Retrouvez les photos des éditions 2017 de ces deux 
                            évènements dans la "]
                    , a [href "/Photothèque.html"]
                        [text "photothèque"]
                 ]
   , expiry = Date.fromString "06/15/2017"
   }
  ,{ emptyNews |
     title = "Randonnée des 6 lacs"
   , date  = Date.fromString "06/19/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "La randonnée solidaire des 6 lacs passe à Murol jeudi 22 juin.
                            Vous pouvez encore vous inscrire sur le "
                    , a [href "http://uneviemeilleure.org/", target "_blank"]
                        [text "site de l'association"]
                    , text "."
                    , br [] []
                    , a [ href "/baseDocumentaire/randonnée solidaire001.pdf"
                        , target "_blank"
                        ]
                        [text "Affiche"]
                    , br [] []
                    , a [ href "/baseDocumentaire/programme rando des 6 lacs.pdf"
                        , target "_blank"
                        ]
                        [text "Programme"]
                    ]
                 ]
   , expiry = Date.fromString "06/23/2017"
   } 
   --,{ emptyNews |
   --  title = "Conte des enfants de l'école de Murol et fête des écoles"
   --, date  = Date.fromString "06/19/2017"
   --, descr = div [class "newsdescr"]
   --              [p []
   --                 [text "Il était une fois une fête des écoles qui a transporté
   --                        les spectateurs au coeur du Moyen-Âge : chevaliers, dragon,
   --                        sorcier, danseurs et chanteurs... rien n'a été oublié par
   --                        les auteurs en herbe de ce conte inédit ! "
   --                 ]
   --              , a [href "/Annee2017.html"]
   --                  [text "Voir les photos"]
   --              , p []
   --                  [a [ href "/baseDocumentaire/conte élémentaire Murol.pdf" 
   --                     , target "_blank"]
   --                     [ text "Conte des enfants de l'école de Murol"]
   --                  ]
   --              ]
   --, expiry = Date.fromString "16/31/2017"
   --}
   ,{ emptyNews |
     title = "Ouverture du centre de loisirs du SIVOM de la Vallée Verte"
   , date  = Date.fromString "06/25/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "il sera ouvert du 10 juillet au 25 aout (sauf 14 juillet
                           et 15 août). Vous pouvez encore inscrire vos enfants
                           selon les places disponibles."
                    ]
                 , p [] [ a [href "/PériEtExtra-scolaire.html?bloc=3"]
                            [text "Présentation du centre de loisirs"]
                        ]
                 , p [] [a [ href "/baseDocumentaire/periscolaire/plaquette CLSH 2017.pdf"
                           , target "_blank"
                           ]
                           [ text "Plaquette de présentation du centre de loisirs été" ]
                        ]
                 , p [] [ a [href "/baseDocumentaire/periscolaire/INSCRIPTION  clsh 2017-2018.pdf", target "_blank"]
                            [text "dossiers d’inscriptions"]
                        ]
                 
                 ]
   , expiry = Date.fromString "07/25/2017"
   }
   ,{ emptyNews |
     title = "Les élèves de l'école de Chambon sur Lac lauréats !"
   , date  = Date.fromString "07/04/2017"
   , descr = div [class "newsdescr"]
                 [ p []
                     [text "Les élèves de l'école de Chambon sur Lac
                           ont reçu le premier prix du concours scolaire du meilleur petit journal du patrimoine. Félicitations!
                           "
                    ]
                 , p [] 
                     [ a [href "http://www.patrimoine-environnement.fr/laureats-2017-concours-scolaire/", target "_blank"]
                         [text "plus d'informations"
                         ]
                     ]
                 , p []
                     [a [href "/baseDocumentaire/JOURNAL CHAMBON_SUR_LAC CM1-CM2.pdf", target "_blank"]
                        [text "le petit journal du patrimoine"]    
                     ]
                 ]
   , expiry = Date.fromString "08/04/2017"
   } 
   ,{ emptyNews |
     title = "Murol info 34 - Spécial circulation et stationnement à Murol"
   , date  = Date.fromString "07/04/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le dernier Murol Infos regroupe les informations
                           concernant la circulation et le stationnement dans la commune"]
                 , p [] 
                     [text "Consultation "
                     , a [ href "/baseDocumentaire/murolInfo/34.pdf"
                         , target "_blank"
                         ]
                         [ text "ici"]
                     ]          
                 ]
   , expiry = Date.fromString "08/31/2017"
   }
   ,{ emptyNews |
     title = "Inauguration des oeuvres Horizons Arts Nature en Sancy"
   , date  = Date.fromString "07/08/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les photos des journées d'inauguration
                          (22 et 23 juin 2017) sont visibles dans la photothèque."]
                 , a [href "/Annee2017.html"]
                     [text "Voir les photos"]
                 ]
   , expiry = Date.fromString "08/08/2017"
   }
   ,{ emptyNews |
     title = "Animation saison estivale - programmes disponibles"
   , date  = Date.fromString "07/08/2017"
   , descr = div [class "newsdescr"]
                 [ p []
                     [ text "La saison estivale arrive avec de nombreuses animations présentées sur des programmes par quinzaine.
                             Retrouvez également le détail de la journée du 14 juillet "
                     ]
                 ,  p []
                      [ text "Voir la "
                      , a [href "/AnimationEstivale.html"] [text "page dédiée"]
                      ]
                 
                 ]
   , expiry = Date.fromString "09/01/2017"
   }
   ,{ emptyNews |
     title = "Photos du Festival d'Art 2017"
   , date  = Date.fromString "08/09/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Les photos de l'édition 2017 du Festival d'Art sont visibles dans la "
                    , a [href "/FestivalArt.html"] [text "photothèque"]]
                 ]
   , expiry = Date.fromString "09/09/2017"
   }
   ,{ emptyNews |
     title = "Mise en ligne de la visite virtuelle aérienne"
   , date  = Date.fromString "08/17/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Prenez de la hauteur et découvrez Murol vu par les drones de la société " 
                    , a [ href "http://www.w3ds.fr/"
                        , target "_blank"
                        
                        ]
                        [text "W3D's"]      
                    , text ". "
                    ]
                  , p []
                      [ text "Voir le "
                      ,  a [ href "visite/visite-virtuelle-aerienne-murol.html"
                           , target "_blank"
                           ]
                          [text "panorama interactif"]
                      , text "."
                      ]
                 ]
   , expiry = Date.fromString "09/17/2017"
   }
   ,{ emptyNews |
      title = "Délibérations du conseil municipal"
    , date  = Date.fromString "08/17/2017"
    , descr = div [class "newsdescr"]
                  [p []
                     [text "Les dernières délibérations du conseil municipal sont
                           disponibles "
                     , a [href "/Délibérations.html"]
                         [text "ici"] 
                     ]
                  ]
    , expiry = Date.fromString "08/31/2017"
    } 
  ,{ emptyNews |
     title = "Vidéo de la réalisation de la charpente du château de Murol"
   , date  = Date.fromString "08/18/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez en vidéo la réalisation de la charpente du château.
                           Montage réalisé à partir d'images d'archives datant du début
                           des années 2000."
                    ]
                 , a [href "/DécouvrirMurol.html?bloc=1#videoCharpente"]
                     [text "Lien ici"]   
                 ]
   , expiry = Date.fromString "09/18/2017"
   }
   ,{ emptyNews |
     title = "le Murol infos 35 est disponible"
   , date  = Date.fromString "09/08/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Retrouvez les activités proposées par la municipalité
                           et les associations dans le "
                    , a [href "/baseDocumentaire/murolInfo/35.pdf"]
                        [text "Murol Infos 35"]
                    ]   
                 ]
   , expiry = Date.fromString "10/08/2017"
   }
   ,{ emptyNews |
     title = "pleins feux sur l’association des jeunes de Murol"
   , date  = Date.fromString "09/12/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les 1/2/3 septembre Murol était en fête grâce à ses jeunes.
                           Retrouvez ici la vidéo du ventriglisse géant diffusée
                           par le journal « La Montagne »"
                    ]
                 , a [href "http://www.lamontagne.fr/murol/insolite/2017/09/02/les-conscrits-font-le-buzz-avec-un-ventriglisse-geant-a-murol_12534803.html"]
                     [text "Voir la vidéo"]   
                 ]
   , expiry = Date.fromString "09/31/2017"
   }
  ,{ emptyNews |
     title = "Emplois saisonniers"
   , date  = Date.fromString "09/20/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le forum des emplois saisonniers se tiendra le jeudi 5 octobre de 14 à 17h à Besse"
                    ]
                 , a [href "/baseDocumentaire/forum besse.pdf"]
                     [text "Lien ici"]   
                 ]
   , expiry = Date.fromString "10/06/2017"
   }
   ,{ emptyNews |
     title = "Fermetures exceptionnelles du musée des peintres"
   , date  = Date.fromString "10/07/2017"
   , descr = div [class "newsdescr"]
                 [ p []
                     [text "Pour raison de formation, le musée des peintres sera fermé :"
                     ]
                 , ul []
                      [ li [] [text "lundi 9/10 : MATIN"]
                      , li [] [text "mardi 17/10 : MATIN"]
                      , li [] [text "mardi 24/10 : JOURNÉE"]
                      ]   
                 ]
   , expiry = Date.fromString "10/25/2017"
   }
   ,{ emptyNews |
     title = "Fermeture exceptionnelle de l'office de tourisme"
   , date  = Date.fromString "10/07/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Nous vous informons que les services des Offices de
                           Tourisme du Massif du Sancy seront exceptionnellement fermés du lundi 9 au mercredi 11/10 inclus.
                           Ré-ouverture au public jeudi 12 octobre à 9h."
                    ]
                 ]
   , expiry = Date.fromString "10/13/2017"
   }
   ,{ emptyNews |
     title = "Actions en faveur des malades de la mémoire et des aidants"
   , date  = Date.fromString "10/11/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La Plateforme de répit 63 organise des ateliers gratuits à la Bourboule pour les personnes
                           atteintes d'une maladie de la mémoire."
                    ]
                 , a [href "baseDocumentaire/Ateliers mémoire.pdf", target "_blank"]
                     [text "Voir le planning"]
                 , p []
                     [text "Les aidants peuvent bénéficier d'un soutien psychologique gratuit à domicile."
                     ]
                 , a [href "baseDocumentaire/SOUTIEN PSYCHOLOGIQUE.pdf" , target "_blank"]
                     [text "Voir la brochure"]   
                 
                 ]
   , expiry = Date.fromString "12/31/2017"
   }
   ,{ emptyNews |
     title = "Octobre rose 2017, prévention du cancer du sein"
   , date  = Date.fromString "10/11/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Un ciné- débat gratuit est organisé à Besse par l'ARDOC,
                           la CAMIEG et le CLIC jeudi 19 octobre à 20h."
                    ]
                 , a [href "baseDocumentaire/OCTOBRE ROSE.pdf", target "_blank"]
                     [text "Communiqué de presse"]   
                 ]
   , expiry = Date.fromString "10/21/2017"
   }
   ,{ emptyNews |
     title = "A la Toussaint, devenez chevalier de Murol !"
   , date  = Date.fromString "10/23/2017"
   , descr = div [class "newsdescr"]
                 [ h6 [] [text "Intégrez l’école de chevalerie
                                de Jean de Murol et devenez chevalier du château !"]
                 , p []
                    [text "Pendant les vacances de la Toussaint, Messire Jean de Murol
                           vous invite à rejoindre ses rangs et à intégrer son école de chevalerie. "
                    ]
                 , p []
                     [ text "Durant cette animation encadrée par ces deux fidèles sergents d’armes,
                             notre vaillant cavalier montrera l’exemple aux enfants en exécutant des
                             démonstrations de joutes, de combats à l’épée et d’exercices équestres."
                     ]
                 , p []
                     [text "Petits et grands pourront assister à ces démonstrations de cavalerie.
                            Les enfants qui participeront seront choisis par nos animateurs et auront
                            entre 6 et 13 ans. "
                     , br [] []
                     , text "Tous les jours sauf le samedi 28 octobre, à 12h, 14h45, 15h45, 16h45."
                     , br [] []
                     , text "Durée : environ 30 minutes."
                     ]
                 , p [] 
                     [text "Venez également découvrir la vie quotidienne d’une seigneurie auvergnate
                            en l’an de grâce 1417 en suivant les habitants de la seigneurie de
                            Guillaume : Guillemette, sa cuisinière ou encore Maître Jean,
                            riche laboureur."
                      ]
                 , p [] [text "Visites guidées tous les jours à 11h, 14h, 15h, 16h et 17h."
                        , br [] []
                        , text "Durée : environ 1h."
                        ]
                 , a [href "http://murolchateau.com/", target "_blank"]
                     [text "Site officiel du château de Murol"]   
                 ]
   , expiry = Date.fromString "11/06/2017"
   }
  ,{ emptyNews |
     title = "Navette Azureva entre Murol et Besse/Super-Besse"
   , date  = Date.fromString "10/23/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Navette proposée par le village-vacances
                          Azureva-Murol pour accéder en toute
                          tranquillité et sécurité aux pistes de ski de Besse
                          et Super-Besse."
                    ]
                 , p []
                     [text "Du lundi au samedi, du 12 février au 10
                            mars 2018"
                     ]
                 , a [href "/baseDocumentaire/Navette Azureva Murol - Superbesse fevrier 2018.pdf", target "_blank"]
                     [text "Horaires et infos pratiques"]   
                 ]
   , expiry = Date.fromString "03/11/2018"
   }
   ,{ emptyNews |
     title = "Les animations du château pour les vacances de Noël"
   , date  = Date.fromString "12/04/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez les animations prévues au château de Murol lors des vacances de Noël dans le "
                    ]
                 , a [href "/baseDocumentaire/CP Château de Murol - Noel 2017.pdf", target "_blank"]
                     [text "communiqué de presse"]   
                 ]
   , expiry = Date.fromString "01/07/2018"
   }
  ,{ emptyNews |
     title = "Fêtes de fin d'année à Murol (décembre/janvier)"
   , date  = Date.fromString "12/08/2017"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez les animations de décembre et janvier dans le "
                    ]
                 , a [href "baseDocumentaire/murolInfo/36.pdf", target "_blank"]
                     [text "Murol infos 36"]   
                 ]
   , expiry = Date.fromString "01/08/2018"
   }
   ,{ emptyNews |
     title = "Centre de loisirs février 2018, inscription avant le 18 janvier"
   , date  = Date.fromString "01/09/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le centre de loisirs du SIVOM de la Vallée Verte sera ouvert du 12 au 23 février 2018."
                    ]
                 , a [href "baseDocumentaire/periscolaire/plaquette fév  2018.pdf", target "_blank"]
                     [text "Plaquette février 2018"]
                 , br [] []
                 , a [href "baseDocumentaire/periscolaire/programme fév 2018.pdf", target "_blank"]
                     [text "Programme février 2018"]
                 , br [] []
                 , a [href "baseDocumentaire/periscolaire/inscription prév février 2018.pdf", target "_blank"]
                     [text "Fiche d'inscription"]   
                 ]
   , expiry = Date.fromString "01/19/2018"
   }
   ,{ emptyNews |
     title = "Vœux du maire 2018"
   , date  = Date.fromString "01/09/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les vœux du maire auront lieu le dimanche 21 janvier 2018 à 11h à la salle des fêtes."
                    ]
                   
                 ]
   , expiry = Date.fromString "01/22/2018"
   }
   ,{ emptyNews |
     title = "Voeux du maire et repas du CCAS"
   , date  = Date.fromString "01/25/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Retrouvez les photos des voeux du maire et du repas du CCAS du 21 janvier dans la photothèque."
                    ]
                 , a [href "/Annee2018.html"]
                     [text "Lien ici"]   
                 ]
   , expiry = Date.fromString "02/25/2018"
   }
   ,{ emptyNews |
     title = "Diaporama de l'année 2017"
   , date  = Date.fromString "01/25/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le diaporama 2017 est disponible dans la photothèque."
                    ]
                 , a [href "/baseDocumentaire/diaporama2017.pdf", target "_blank"]
                     [text "Télécharger"]   
                 ]
   , expiry = Date.fromString "02/25/2018"
   }
   ,{ emptyNews |
     title = "Offre d'emploi"
   , date  = Date.fromString "02/03/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La mairie de Murol recherche un agent technique."
                    ]
                 , a [href "baseDocumentaire/CDD 6 mois - agent technique - CT Murol.pdf", target "_blank"]
                     [text "Voir l'offre"]   
                 ]
   , expiry = Date.fromString "04/03/2018"
   }
  ,{ emptyNews |
     title = "Sancy Snow Jazz à Murol"
   , date  = Date.fromString "02/08/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Dans le cadre du Sancy Snow Jazz, la commune de Murol accueille le concert de SWINGROCKET dimanche 11 février 2018 à 20h à la salle des fêtes. Entrée libre"
                    ]
                 , a [href "baseDocumentaire/afficheJazz.pdf", target "_blank"]
                     [text "Lien affiche"]   
                 ]
   , expiry = Date.fromString "02/12/2018"
   }
   ,{ emptyNews |
     title = "Une nouvelle boulangerie à Murol !"
   , date  = Date.fromString "02/13/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le \"Fournil du château\" ouvre ses portes rue George Sand mercredi 14 février."]
                 , p [] 
                     [text "Irina et Renaud LUCE vous proposent leurs produits de fabrication artisanale de 7h00 à 13h30 et de 16h00 à 19h30 (en continu en juillet et août)."]
                 , p []
                     [text "Ouverture 7 jours sur 7 pendant les vacances scolaires toutes zones, fermeture le dimanche après-midi et le lundi le reste de l'année."
                     ] 
                 ]
   , expiry = Date.fromString "03/13/2018"
   }
   ,{ emptyNews |
     title = "Dispositif OrganiCité"
   , date  = Date.fromString "03/15/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez les actions engagées dans "
                    ]
                 , a [href "/baseDocumentaire/lettre OrganiCité n°2.pdf", target "_blank"]
                     [text "la lettre OrganiCité n°2"]   
                 ]
   , expiry = Date.fromString "04/15/2018"
   }
   ,{ emptyNews |
     title = "Animation \"Tous au compost!\" samedi 24 mars"
   , date  = Date.fromString "03/15/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "une animation est organisée par le réseau compost citoyen et la mairie de Murol aux services techniques (rue de Jassat) samedi 24 mars de 9h à 12h."
                    ]
                 , a [href "/baseDocumentaire/affiche animation compost.pdf", target "_blank"]
                     [text "Voir l'affiche"]   
                 ]
   , expiry = Date.fromString "03/25/2018"
   }
   ,{ emptyNews |
     title = "Le bulletin municipal n°9"
   , date  = Date.fromString "03/15/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le dernier bulletin municipal est en ligne."
                    ]
                 , a [href "/baseDocumentaire/bulletin/mars2018.pdf", target "_blank"]
                     [text "Télécharger"]   
                 ]
   , expiry = Date.fromString "04/15/2018"
   }
   ,{ emptyNews |
     title = "Centre de loisirs du SIVOM de la Vallée Verte, vacances de printemps"
   , date  = Date.fromString "03/22/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Il reste quelques places au centre de loisirs du SIVOM de la Vallée Verte pour les vacances de printemps. Les inscriptions sont encore possibles."
                    ]
                 , p [] 
                     [ text "Découvrez la "
                     , a [href "/baseDocumentaire/periscolaire/plaquette avril 2018.pdf", target "_blank"] [text "plaquette avril"]
                     , text ". Les documents d'inscription sont "
                     , a [href "/PériEtExtra-scolaire.html?bloc=3"] [text "en ligne"]
                     , text "."
                     ]
                        
                 ]
   , expiry = Date.fromString "04/22/2018"
   }
   ,{ emptyNews |
     title = "Opération \"Argent de poche\" 2018"
   , date  = Date.fromString "03/25/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les jeunes de la commune âgés de 14 à 18 ans vont pouvoir participer à l'opération \"Argent de poche\" pendant les vacances scolaires de printemps, d'été et d'automne 2018."
                    ]
                 , p [] 
                     [text "Inscrivez-vous avant le 3 avril 2018 pour les vacances de printemps!"]
                 , a [href "/baseDocumentaire/plaquette printemps 2018 argent de poche.pdf", target "_blank"]
                     [text "plaquette de printemps"]
                 , br [] []
                 , a [href "/baseDocumentaire/Dossier d'inscription argent de poche 2018.pdf", target "_blank"]
                     [text "dossier d'inscription"]       
                 ]
   , expiry = Date.fromString "04/04/2018"
   }  
  ,{ emptyNews |
     title = "Offres d'emplois saisonniers"
   , date  = Date.fromString "03/25/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La commune de Murol recherche pour cet été :"
                    ]
                 --, a [href "/baseDocumentaire/offre responsable de surveillance de baignade 2018.pdf", target "_blank"]
                 --    [text "un(e) responsable de surveillance de baignade"]
                 --, br [] []
                 , a [href "/baseDocumentaire/offre surveillants de baignade 2018.pdf", target "_blank"]
                     [text "des surveillant(e)s de baignade"]
                 --, br [] []
                 --, a [href "/baseDocumentaire/offre responsable  animation 2018.pdf", target "_blank"]
                 --    [text "un(e) responsable de l'animation estivale"]   
                 ]
   , expiry = Date.fromString "07/01/2018"
   }
   ,{ emptyNews |
     title = "Commande de composteur individuel"
   , date  = Date.fromString "04/08/2018"
   , descr = div [class "newsdescr"]
                 [ a [href "/baseDocumentaire/reservComposteur.pdf", target "_blank"]
                     [text "Télécharger le bon de réservation"]   
                 ]
   , expiry = Date.fromString "09/01/2018"
   }
   ,{ emptyNews |
     title = "Collecte des pesticides des particuliers"
   , date  = Date.fromString "04/19/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [ b [] [text "Jusqu’au 29 avril "]
                    , text "Une opération de collecte des pesticides des particuliers est organisée en partenariat avec le Valtom et ses collectivités.  Sont concernés les produits phytosanitaires des particuliers, entamés ou non utilisés, dans leur emballage d’origine :"
                    , br [] []
                    , text "anti-mousses, herbicides, fongicides, insecticides, anti-limaces, engrais non organiques, etc.
Toutes les informations pratiques sont sur le "
                    , a [href "http://www.valtom63.fr/actualites/operation-en-route-vers-zero-pesticide/", target "_blank"]
                     [text "site du Valtom"]
                    ]          
                 ]
   , expiry = Date.fromString "04/30/2018"
   }
   ,{ emptyNews |
     title = "Médiévales 2018 : vendredi 11 et samedi 12 mai"
   , date  = Date.fromString "05/08/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Murol va vivre deux jours au rythme du Moyen-Âge! Découvrez le "
                    ]
                 , a [href "/baseDocumentaire/animation/programme Médiévales 2018.pdf", target "_blank"]
                     [text "programme"]   
                 ]
   , expiry = Date.fromString "05/13/2018"
   }
   ,{ emptyNews |
     title = "Nuit européenne des musées à Murol : samedi 19 mai à 20h30"
   , date  = Date.fromString "05/17/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le musée des Peintres de l’École de Murols proposera aux visiteurs une rencontre entre deux arts majeurs, la peinture et la musique."
                    ]
                 , p []
                     [text "Les chants de la chorale de la Vallée Verte entreront en résonance avec les œuvres post-impressionnistes des artistes de l’École de Murols qui, au début du XXe siècle, se sont regroupés autour de maîtres comme Victor Charreton, Armand Point et Wladimir de Terlikowski avec lesquels ils ont pu partager leur passion pour les paysages de neige du massif du Sancy."]   
                 , a [href "/baseDocumentaire/affiche nuit des musées bandeau.pdf", target "_blank"]
                     [text "Voir l'affiche"]   
                 ]
   , expiry = Date.fromString "05/20/2018"
   }
   ,{ emptyNews |
     title = "Concert pour Rétina : vendredi 25 mai à 20h30 église de Murol"
   , date  = Date.fromString "05/17/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les chorales des Grains de Folies et de la Vallée Verte seront en concert en faveur de la recherche médicale en ophtalmologie. Venez nombreux!"
                    ]
                 , a [href "/baseDocumentaire/affiche retina.pdf", target "_blank"]
                     [text "Voir l'affiche"]   
                 ]
   , expiry = Date.fromString "05/26/2018"
   }
   ,{ emptyNews |
     title = "Centre de loisirs - été 2018"
   , date  = Date.fromString "05/17/2018"
   , descr = div [class "newsdescr"]
                 [ p []
                     [text "Centre de loisirs pour les 3 à 11 ans:
                            retrouvez les programmes d'activités de
                            cet été ainsi que le dossier d'inscription
                             "
                     , a [href "/PériEtExtra-scolaire.html?bloc=3"]
                     [text "ici"]     
                     ]

                 
                 ]
   , expiry = Date.fromString "09/01/2018"
   }

   ,{ emptyNews |
     title = "Photos des Médiévales 2018"
   , date  = Date.fromString "05/17/2018"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Les photos des Médiévales 2018 sont disponibles dans la photothèque.
                               Si vous avez des photos que vous souhaitez partager, contactez le webmaster."]
                 , a [href "/Medievales.html"] [text "Lien photothèque"]
                 ]
   , expiry = Date.fromString "06/15/2018"
   }
   ,{ emptyNews |
     title = "Vidéo des Médiévales 2018"
   , date  = Date.fromString "05/22/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "A découvrir sur "
                    
                 , a [href "https://www.youtube.com/watch?v=rwnkX4ZpR5Q", target "_blank"]
                     [text "youtube"]   
                 ]
                 ]
   , expiry = Date.fromString "06/22/2018"
   }
   ,{ emptyNews |
     title = "Article sur les Médiévales"
   , date  = Date.fromString "05/22/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Fabienne Sauvageot, nous fait partager ses impressions sur Murol et les Médiévales "
                    ]
                 , p [] 
                     [ text "A découvrir sur son blog " 
                     , a [href "https://aleaudevichy.wordpress.com/2018/05/12/les-medievales-de-murol/", target "_blank"]
                         [text "ici"]
                     ]   
                 ]
   , expiry = Date.fromString "06/22/2018"
   }
  
  ,{ emptyNews |
     title = "Informations du SIVOM de la Vallée Verte"
   , date  = Date.fromString "06/20/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les programmes du centre de loisirs ainsi que les documents d'inscriptions à la cantine et garderie pour l'année scolaire 2018/2019 sont en ligne sur la page "
                    , a [href "/PériEtExtra-scolaire.html"]
                        [text "péri et extra scolaire"]   
                    ]
                 ]
   , expiry = Date.fromString "07/20/2018"
   }
   ,{ emptyNews |
     title = "Les animations de juillet 2018"
   , date  = Date.fromString "06/20/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez les animations estivales des communes de la vallée verte (Chambon sur Lac, Murol et Saint Nectaire) dans la "
                    
                    , a [href "baseDocumentaire/animation/programme des animations de la vallée verte juillet 2018.pdf", target "_blank"]
                       [text "brochure"]   
                 ]
                 ]
   , expiry = Date.fromString "07/31/2018"
   }
  ,{ emptyNews |
     title = "Fête de la musique à Murol : 21 juin"
   , date  = Date.fromString "06/20/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez le programme "
                    , a [href "/baseDocumentaire/Fête de la musique 2018.pdf"
                        , target "_blank"]
                        [text "ici"]
                    ]    
                 ]
   , expiry = Date.fromString "06/22/2018"
   }
   ,{ emptyNews |
     title = "Murol Infos 37"
   , date  = Date.fromString "07/02/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "Le nouveau \"Murol Infos\" (juin 2018) est disponible: "
                    , a [href "baseDocumentaire/murolInfo/37.pdf"] [text "Télécharger"]]
                 ]
   , expiry = Date.fromString "08/02/2018"
   }
  ,{ emptyNews |
     title = "Argent de Poche - été 2018"
   , date  = Date.fromString "07/02/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le dispositif \"Argent de Poche\" est ouvert aux jeunes pour l'été"
                    ]
                 , a [href "baseDocumentaire/ados/plaquette été 2018 argent de poche.pdf", target "_blank"]
                     [text "Plaquette été 2018"]
                 , br [] []
                 , br [] []
                 , a [href "baseDocumentaire/ados/Dossier d'inscription argent de poche 2018.pdf", target "_blank"]
                     [text "Dossier d'inscription"]   
                 ]
   , expiry = Date.fromString "08/31/2018"
   }
  ,{ emptyNews |
     title = "Exposition estivale des Amis du vieux Murol"
   , date  = Date.fromString "07/02/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les amis du vieux Murol proposent leur exposition estivale"
                    ]
                 , a [href "/baseDocumentaire/animation/expo 2018 amis du vieux murol.pdf", target "_blank"]
                     [text "Voir l'affiche"]   
                 ]
   , expiry = Date.fromString "08/31/2018"
   }
   ,{ emptyNews |
     title = "1er prix du trophée EDF du patrimoine Aurhalpin"
   , date  = Date.fromString "07/10/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Suite aux travaux d’illuminations du château, la commune de Murol a obtenu le 1er prix du trophée EDF qui récompense la meilleure valorisation d’un élément du patrimonial régional par sa mise en lumière."
                    ]
                 ]
   , expiry = Date.fromString "08/10/2018"
   }
  ,{ emptyNews |
     title = "1er juillet, Murol fait sa révolution"
   , date  = Date.fromString "07/10/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez le "
                    ]
                 , a [href "baseDocumentaire/animation/affiche14juillet2018.pdf", target "_blank"]
                     [text "programme 2018"]   
                 ]
   , expiry = Date.fromString "07/15/2018"
   }
   ,{ emptyNews |
     title = "Recherche de témoignages de personnes gênées par l'ambroisie"
   , date  = Date.fromString "07/19/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "l'Observatoire des ambroisies et la Direction Générale de la Santé :"
                    , br [] []
                    , br [] []
                    , text "Nous sommes à la recherche de témoignages de personnes qui sont gênées par l’ambroisie : symptômes gênants, impossibilité de travailler, besoin de déménager à cause de l’ambroisie, etc. Bref, tout témoignage qui démontre la nuisibilité de l’ambroisie."
                    , br [] []
                    , text "Ces témoignages peuvent être sous n’importe quel format : vidéo, par écrit … que vous voudrez bien transmettre à l'adresse mail suivante:"
                    ]
                 , a [href "mailto:conseillersmurol@gmail.com", target "_Top"]
                     [text "conseillersmurol@gmail.com"]   
                 , p [] 
                     [ text "Document "
                     , a [href "/baseDocumentaire/Flyer_AmbroisieV4.pdf", target "_blank"] 
                         [text "reconnaître l'ambroisie"] 
                     ]
                 ]
   , expiry = Date.fromString "08/06/2018"
   }
  ,{ emptyNews |
     title = "Dysfonctionnement du feu d'artifice du 14 juillet"
   , date  = Date.fromString "07/22/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le feu d'artifice du 14 juillet ne s'est pas déroulé selon le programme annoncé. Voir le "
                    ]
                 , a [href "baseDocumentaire/message feu d'artifice.pdf", target "_blank"]
                     [text "message du maire"]   
                 ]
   , expiry = Date.fromString "08/22/2018"
   }
   ,{ emptyNews |
     title = "Festival d'Art : dimanche 29 juillet"
   , date  = Date.fromString "07/26/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez le "
                    ]
                 , a [href "baseDocumentaire/animation/afficheFestivalArt2018.pdf", target "_blank"]
                     [text "programme"]   
                 ]
   , expiry = Date.fromString "08/01/2018"
   }
   ,{ emptyNews |
     title = "La chaine des Puys-Faille de la Limagne dans le patrimoine de l'Unesco!"
   , date  = Date.fromString "08/03/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Le 2 juillet 2018, le comité du patrimoine mondial réuni à Bahreim a décidé d'inscrire ce haut lieu tectonique. Pour plus de renseignements: "
                    ]
                 , a [href "http://www.chainedespuys-failledelimagne.com/?actualite=la-chaine-des-puys-faille-de-limagne-inscrite-au-patrimoine-mondial-de-lunesco", target "_blank"]
                     [text "voir ici"]   
                 ]
   , expiry = Date.fromString "12/01/2018"
   }
   ,{ emptyNews |
     title = "Les animations d'août 2018"
   , date  = Date.fromString "08/03/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Découvrez les animations estivales des communes de la Vallée Verte (Chambon sur Lac, Murol et Saint Nectaire) dans la "
                    
                 , a [href "baseDocumentaire/animationsAout2018.pdf", target "_blank"]
                     [text "brochure"]]   
                 ]
   , expiry = Date.fromString "09/01/2018"
   }
   ,{ emptyNews |
     title = "Les photos de la 5ème édition du festival d'Art de Murol"
   , date  = Date.fromString "08/03/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les photos sont disponibles dans la "
                    
                 , a [href "/FestivalArt.html"] [text "photothèque"]]  
                 ]
   , expiry = Date.fromString "09/01/2018"
   }
   ,{ emptyNews |
     title = "Concert \"l'âme slave\" dimanche 19 août "
   , date  = Date.fromString "08/17/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Venez profiter du concert de deux virtuoses de la musique russes à 20h30 à l'église de Murol !"
                    ]
                 , a [href "baseDocumentaire/animation/concert église 19-8-18.pdf", target "_blank"]
                     [text "Voir l'affiche"]   
                 ]
   , expiry = Date.fromString "08/20/2018"
   }
   ,{ emptyNews |
     title = "Reprise des activités pour la rentrée"
   , date  = Date.fromString "09/03/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les associations font leur rentrée et vous invitent à les rejoindre :"
                    



                    ]
                 , ul [] 
                         [ li [] [ a [target "_blank", href "baseDocumentaire/Ensemble Instrumental de la Vallée Verte.pdf"]
                                     [text "L'ensemble instrumental de la vallée verte"]
                                 , text " dont la chorale fait sa première répétition mardi 4 septembre à 20h à la salle des fêtes"
                                 ]
                         , li [] [ text "Les balades "
                                 , a [target "_blank", href "baseDocumentaire/Marchons dans nos campagnes.pdf"]
                                     [text "Marchons dans nos campagnes"]
                                 , text " proposées par le Clic pour les séniors dès le vendredi 14 septembre à 14h"
                                 ]
                         , li [] [ text "les activités sportives proposées par "
                                 , a [ target "_blank", href "baseDocumentaire/Sancy Sports et Loisirs.pdf"] 
                                     [text "Sancy Sports et Loisirs"]
                                 , text " dès le mardi 17 septembre"
                                 ]
                         ]
                 , p [] 
                     [ text "D'autres associations ( ACTVV, Amis du Vieux Murol...) nous transmettront prochainement leurs programmes, nous vous les communiquerons."]
                    
                 ]
   , expiry = Date.fromString "10/03/2018"
   }
   ,{ emptyNews |
     title = "Activités dans la vallée, suite..."
   , date  = Date.fromString "09/11/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [ text "L'association culture et tradition de la vallée verte (ACTVV) propose de "
                    ,  a [href "baseDocumentaire/Les activités 2018-2019 ACTVV.pdf", target "_blank"]
                         [text "nombreuses activités toute l'année"]
                    , text "."
                    ]
                 , p []
                     [text "Nouveau! Les ateliers Zelle proposent des "
                     , a [href "baseDocumentaire/ateliers Zelle.pdf", target "_blank"]
                         [text "activités musicales"]
                     , text " à partir de 3 ans."  
                     ]
                  
                 ]
   , expiry = Date.fromString "12/31/2018"
   }
   
    
  ,{ emptyNews |
     title = "La rentrée en musique"
   , date  = Date.fromString "09/20/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Cette année, les écoliers de Murol et Chambon sur Lac ont eu droit à faire leur rentrée en musique grâce au concours des instrumentistes de l'ensemble instrumental des la vallée verte"
                    ]
                 , a [href "Annee2018.html"]
                     [text "Voir les photos"]   
                 ]
   , expiry = Date.fromString "10/20/2018"
 }
   ,{ emptyNews |
     title = "La commune de Murol a reçu le trophée EDF" 
   , date  = Date.fromString "09/20/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "La cérémonie de remise du trophée EDF récompensant la mise en lumière des remparts du château a eu lieu mercredi 19 septembre"
                    ]
                 , a [href "baseDocumentaire/dossier de presseEDF.pdf", target "_blank"]
                     [text "Voir le dossier de presse"]   
                 , br [] []
                 , a [href "Annee2018.html"]
                     [text "Voir les photos"]
                 ]

   , expiry = Date.fromString "10/20/2018"
   }
   ,{ emptyNews |
     title = "Samedi 22 et dimanche 23 septembre : spectacles du projet terre-eau de la paix"
   , date  = Date.fromString "09/20/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Vous pourrez assister aux productions dansées du projet Terre-Eau de la Paix les 22 et 23 septembre 2018 à 15h30 au Lac Chambon, plage de Murol. Cette manifestation émane de la collaboration entre l’association des Maires Ruraux du Puy de Dôme, porteur du projet, le Master international Choréomundus, et l’association Passeurs de danse. Ce projet s’inscrit dans une démarche de promotion de la Paix à travers la coopération artistique interculturelle des acteurs. Il rend hommage, en la prolongeant, à la journée internationale de la Paix (21 septembre). Spectacle gratuit."
                    ]
                 , a [href "/baseDocumentaire/animation/Terre-eau de la paix.jpg", target "_blank"]
                      [text "voir l'affiche"]   
                 ]
   , expiry = Date.fromString "09/24/2018"
   }
   ,{ emptyNews |
     title = "Performances dansées Terre-eau de la Paix"
   , date  = Date.fromString "09/25/2018"
   , descr = div [class "newsdescr"]
                 [p []
                    [text "Les photos des spectacles des 22 et 23 septembre à la plage sont disponibles dans la "
                    ]
                 , a [href "Annee2018.html"]
                     [text "photothèque"]   
                 ]
   , expiry = Date.fromString "10/25/2018"
   }    
           
  --,{ emptyNews |
  --   title = ""
  -- , date  = Date.fromString ""
  -- , descr = div [class "newsdescr"]
  --               [p []
  --                  [text ""
  --                  ]
  --               , a [href "", target "_blank"]
  --                   [text "Lien ici"]   
  --               ]
  -- , expiry = Date.fromString ""
  -- }  
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





