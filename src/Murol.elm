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
      [ renderNewsList address "Actualités de la commune" n1
      , renderListImg logos
      , renderMisc
      ]



renderNewsList : Signal.Address Action -> String -> List News -> Html
renderNewsList address title xs =
  div [class (title |> words |> List.map capitalize |> join "")]
      ([ h4 [] [text title]
       , p  [ id "lastUpdate" ]
            [text "Dernière mise à jour le mardi 14 mars 2017"]
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
      , div [id "chateauDivers"]
            [ 
            --  text "Fermeture annuelle du "
            --, a [href "http://www.musee-murol.fr/fr", target "_blank" ]
            --    [ text " musée des peintres de l’Ecole de Murols"]
            --, p [] [text "Réouverture le 23 décembre."]
              p [] [ text "A partir du 18 février, le château sera ouvert tous les jours de 10h à 18h." ] 
            , p [] [ text "Plus d'informations sur le nouveau site officiel : "
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
                [ text "Pour une visite en famille :"
                --, a [ href "baseDocumentaire/Carte jeu de piste 2016.pdf", target "_blank"]
                    --[ text "carte jeu de piste"]
                , text " le "
                , a [ href "baseDocumentaire/livret jeu musée 2017.pdf", target "_blank"]
                    [ text "livret jeu"]
                ]
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
      , iframe [ src "https://calendar.google.com/calendar/embed?showTitle=0&showTabs=0&showNav=0&showPrint=0&showCalendars=0&showTz=0&mode=AGENDA&height=150&wkst=2&hl=fr&bgcolor=%23FFFFFF&src=chldn4cf472b1le89c6qocsugc%40group.calendar.google.com&color=%2329527A&src=1claq68scg7llpg29j2fasprtk%40group.calendar.google.com&color=%23B1440E&src=k1f61irouk8ra89maeu6rgdqr0%40group.calendar.google.com&color=%23AB8B00&src=llf7dsbh7ivhvv15sdc14ndi94%40group.calendar.google.com&color=%23182C57&src=53uq1md0197h673u1kh7l9nmn0%40group.calendar.google.com&color=%232F6309&ctz=Europe%2FParis"
               ] []
      , p [] [a [href "/Animation.html"]
                [text "Consulter le calendrier"]
             ]
      , p [] [a [href "/Animation.html"] [text "Programmes des manifestations"]]
      ] 
      
renderMiniGallery address model = 
  div [id "minGalDiv", class "submenu"]
      [ h3 [] [text "Coup d'oeil sur la photothèque"]
      , Gallery.viewM (Signal.forwardTo address GalleryAction) (.miniGallery model)
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
   ,{ emptyNews |
     title = "Chaîne des Puys & Faille de Limagne - nouveau film"
   , date  = Date.fromString "03/11/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Découvrez, les Origines de la Terre, le "
                        , a [ href "https://www.youtube.com/watch?v=nkWlN3u2evc"
                            , target "_blank"]
                            [text "nouveau film"]
                        , text " promotionnel de la candidature au patrimoine mondial 
                               pour la Chaîne des Puys et la faille 
                               de Limagne. "
                        ]
                 ]
   , expiry = Date.fromString ""
   } 
   ,{ emptyNews |
     title = "Survol du château de Murol en drone - Vidéo"
   , date  = Date.fromString "03/11/2016"
   , descr = div [class "newsdescr"]
                 [ p [] [text "Film réalisé par Andrzej W Szczygiel (entreprise PROP-EYE LTD)"]
                 , p [] [a [href "https://youtu.be/tY89AZLnvZc", target "_blank"]
                           [text "voir la vidéo"]
                        ] 
                 ]
   , expiry = Date.fromString ""
   } 
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
  --,{ emptyNews |
   --  title = ""
   --, date  = Date.fromString ""
   --, descr = div [class "newsdescr"]
   --              [p []
   --                 [text ""]
   --              ]
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





