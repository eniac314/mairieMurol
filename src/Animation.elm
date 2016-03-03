module Animation where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Murol exposing (mainMenu,
                       renderMainMenu',
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       mail,
                       site,
                       link)

-- Model

initialModel =
  { mainMenu = mainMenu
  , drops = [ medievales
            , musee 
            , horizon
            , revolution
            , festivalArt
            ]
  }


type alias Dropable = 
  { intro : (Signal.Address Action -> Html)
  , body  : List Html
  , drop  : Bool
  , id    : Int
  }

tag i n xs =
 case xs of
      [] -> []
      (x::xs') -> {x | id = i+n} :: tag i (n+1) xs'  

dropN id n = if .id n == id
             then {n | drop = not (.drop n)}
             else n

nullTag = span [style [("display","none")]] []

insertDrop : Signal.Address Action -> List Dropable -> Int -> Html
insertDrop address ds n = 
  let drop'   = head (List.filter (\d -> .id d == n) ds)
      content = 
        case drop' of
          Nothing -> nullTag
          Just { intro, body, drop, id } ->
            let body' =
                 if drop
                 then div [class "dropBody"] body
                 else nullTag 
                
                arrow =
                 if drop
                 then img [src "/images/uArrow.jpeg"] []
                 else img [src "/images/dArrow.jpeg"] []

            in
            div [class "dropable"]
                [ div [class "dropHeader"] 
                      [ span [class "arrow"] [arrow]
                      , intro address
                      ]
                , body'
                ]   

  in content 

initDropable : Int -> String -> Maybe Html -> List Html -> Dropable
initDropable id title extra body =
  let intro = 
        (\a -> div [class "dropIntro"]
                   [ h5 [class "dropTitle", onClick a (Drop id)]
                        [text title]
                   , br [] []
                   , Maybe.withDefault nullTag extra
                   ]
        ) 
  in Dropable intro body False id 

-- View
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Animation"] (.mainMenu model)
      , div [ id "subContainer"]
            [ div [ class "subContainerData noSubmenu", id "animation"]
                  [ h2 [] [text "Animation"]
                  , p [] [text "La commune de Murol, riche d’un service animation 
                               municipal et d’une trentaine d’associations dynamiques, offre diverses 
                               animations à sa population locale et à ses 
                               visiteurs tout au long de l’année. Voir le 
                               calendrier ci-dessous."]
                  , p [] [text "De plus, plusieurs grandes manifestations culturelles annuelles s’égrainent 
                               au cours de l’année à Murol. Dans l’ordre 
                               du calendrier, on voit apparaître : "]

                  , insertDrop address (.drops model) 0
                  , insertDrop address (.drops model) 1 
                  , insertDrop address (.drops model) 2 
                  , insertDrop address (.drops model) 3
                  , insertDrop address (.drops model) 4  
                  
                  , h4 [] [text "Calendrier"]
                  , div [ id "bigAgenda"] 
                        [ iframe [src "https://calendar.google.com/calendar/embed?showTitle=0&height=600&wkst=1&amp;bgcolor=%23FFFFFF&src=1fjlvjccl360lavomr84oglecc%40group.calendar.google.com&color=%231B887A&amp;ctz=Europe%2FParis"] []
                        ]
                  ]
            ]
      , pageFooter
      ]


-- Update

type Action 
  = NoOp
  | Drop  Int

update action model =
  case action of
    NoOp    -> model
    Drop id -> 
      let n1 = List.map (dropN id) (.drops model)
      in ({ model | drops = n1 })


--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

  
      

-- Data

medievales = 
  initDropable 0 
               "Les Médiévales de Murol"
               (Just ( a [ href "/Medievales.html"]
                         [ text "lien photothèque"] ))
               ( [ p [] [text "Cette manifestation, organisée par la mairie de 
                               Murol, l’association AMMA et d’autres associations partenaires, 
                               a lieu chaque année durant le week-end de 
                               l’Ascension." ]
                 , p [] [text "Au pied du château du XIIIème siècle, les 
                               rues de Murol vivent au rythme du Moyen-âge 
                               avec pour décor un campement médiéval, des danses, 
                               des spectacles médiévaux, ainsi que des artisans tout 
                               droit sortis du Moyen-âge. Immersion garantie !"]
                 ]
               )

musee = 
  initDropable 1 
               "L’exposition temporaire au musée des Peintres de l’Ecole de Murols"
               (Just ( a [ href "http://www.musee-murol.fr/fr", target "_blank"]
                         [ text "site officiel"] ))
               ( [ p [] [text "Chaque année, le dernier week-end de mai,
                               la commune organise le vernissage d’une 
                               exposition temporaire inédite au musée des Peintres de 
                               l’Ecole de Murols. 
                               L’exposition reste en place jusqu’au 31 octobre. L’objectif 
                               est de regrouper et de présenter pendant quelques 
                               mois les œuvres de l’un des peintres majeurs 
                               de l’Ecole de Murols." ]
                 ]
               )

horizon = 
  initDropable 2 
               "Horizon, rencontres Art et Nature"
               (Just ( a [ href "www.horizons-sancy.com", target "_blank"]
                         [ text "site officiel"] ))
               ( [ p [] [text "Cette manifestation culturelle est organisée par la communauté 
                               de communes du massif du Sancy. La commune 
                               de Murol soutient cet événement en tant que 
                               membre de la communauté de communes et a 
                               déjà accueilli de nombreuses œuvres sur son territoire." ]
                 , p [] [text "Les œuvres éphémères sont installées de juin à 
                               septembre sur des sites naturels. Cette manifestation prend 
                               une ampleur considérable qui dépasse le cadre régional 
                               et même national. "]
                 ]
               )

revolution = 
  initDropable 3
               "La fête de la Révolution"
               (Just ( a [ href "/Revolution.html" ]
                         [ text "lien photothèque"] ))
               ( [ p [] [text "La municipalité de Murol, en partenariat avec différentes 
                               associations de la commune, organise le 14 juillet 
                               dans les rues de Murol. " ]
                 , p [] [text "En journée : reconstitution en costumes d’époque de la Révolution française, 
                               animations de rues, cavalcade, et taverne révolutionnaire. "]
                 , p [] [text "Le soir : défilé costumé suivi du feu 
                               d’artifice tiré du château de Murol et du 
                               bal des pompiers. "]
                 , p [] [text "Vous souhaitez prendre part activement à la fête 
                               ? Louez un costume ! Renseignement à la 
                               mairie de Murol"]
                 ]
               )

festivalArt = 
  initDropable 4
               "Le festival d’Art"
               (Just ( a [ href "/FestivalArt.html" ]
                         [ text "lien photothèque"] ))
               ( [ p [] [text "Le service animation de la mairie organise chaque 
                               été le festival d’Art." ]
                 , p [] [text "Ce festival regroupe de très nombreux artistes et 
                               artisans d’art venus de tous horizons. Leurs 
                               œuvres envahissent les rues et places de Murol 
                               durant une journée d’été riche en couleurs. Petits 
                               et grands déambulent accompagnés par les animations de 
                               rue jusqu’au soir où ils peuvent partager l’ambiance 
                               festive du concert de clôture."]
                 , p [] [ text "Vous voulez venir présenter vos œuvres ? Contactez 
                               la mairie au 04 73 88 60 67 
                               ou par mail à "
                        , a [href "mailto:murolanimation@orange.fr"]
                            [text "murolanimation@orange.fr"]
                        ]
                 ]
               )