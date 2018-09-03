module Animation where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import TiledMenu exposing (initAtWithLink,view,update,Action)
import StarTable exposing (makeTable, emptyTe, Label(..))
import Utils exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu : Utils.Submenu
subMenu = { current = "", entries = []}

type alias MainContent = 
  { wrapper : (Html -> Bool -> Html)
  , tiledMenu :  TiledMenu.Model
  } 

type alias Model = 
  { mainMenu    : Utils.Menu
  , subMenu     : Utils.Submenu
  , mainContent : MainContent
  , showIntro   : Bool
  }  

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  , showIntro   = if String.isEmpty locationSearch
                  then True
                  else False
  }

-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu ["Animation"] (.mainMenu model)
      , div [ id "subContainer"]
            [ (.wrapper (.mainContent model))
               (TiledMenu.view (Signal.forwardTo address TiledMenuAction) (.tiledMenu (.mainContent model)))
               (.showIntro model)
            ]
      , pageFooter
      ]
-- Update

type Action =
    NoOp
  | TiledMenuAction (TiledMenu.Action)

update : Action -> Model -> Model
update action model =
  case action of
    NoOp    -> model
    TiledMenuAction act ->
      let mc = (.mainContent model)
          tm = (.tiledMenu (.mainContent model))
      in
          { model | 
            showIntro = not (.showIntro model)
            , mainContent = 
               { mc | tiledMenu = TiledMenu.update act tm }
          }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

port locationSearch : String

initialContent =
  { wrapper = 
    (\content showIntro ->
       div [ class "subContainerData noSubmenu", id "periscolaire"]
           [ h2 [] [text "Animation"]
           , p [classList [("intro",True),("displayIntro", showIntro)]]
               [text "La commune de Murol offre, tout au long de l’année, diverses animations à sa population locale et à ses visiteurs  grâce à un service municipal dédié et d’une trentaine d’associations dynamiques. Voir le calendrier ci-dessous."]
           , p [classList [("intro",True),("displayIntro", showIntro)]]
               [text "De plus, Murol est le site de grandes manifestations culturelles annuelles :"]

           , content
           
           , h4 [classList [("intro",True),("displayIntro", showIntro)]]
                [text "Calendrier"]
           , div [ id "bigAgenda", classList [("intro",True),("displayIntro", showIntro)]] 
                 [ iframe [src "https://calendar.google.com/calendar/embed?showTitle=0&height=600&wkst=1&amp;bgcolor=%23FFFFFF&src=chldn4cf472b1le89c6qocsugc%40group.calendar.google.com&color=%2329527A&src=1claq68scg7llpg29j2fasprtk%40group.calendar.google.com&color=%23B1440E&src=k1f61irouk8ra89maeu6rgdqr0%40group.calendar.google.com&color=%23AB8B00&src=llf7dsbh7ivhvv15sdc14ndi94%40group.calendar.google.com&color=%23182C57&src=53uq1md0197h673u1kh7l9nmn0%40group.calendar.google.com&color=%232F6309&ctz=Europe%2FParis"] []                        ]
                  
           ])
  , tiledMenu =
      initAtWithLink locationSearch anim
  }
--Data

anim =
  [ ("Médiévales de Murol"
    ,"/images/tiles/animation/medievales.jpg"
    , [ h5 [] 
           [text "Date: Pont de l’Ascension"]
      , a [ href "/Medievales.html"]
          [ text "lien photothèque"]    
      , p [] [text "Cette manifestation, organisée par la mairie de 
                    Murol et des associations partenaires, 
                    a lieu chaque année durant le week-end de 
                    l’Ascension." ]
      , p [] [text "Au pied du château du XIIIème siècle, les 
                    rues de Murol vivent au rythme du Moyen-âge 
                    avec pour décor un campement médiéval, des danses, 
                    des spectacles médiévaux, ainsi que des artisans tout 
                    droit sortis du Moyen-âge. Immersion garantie !"]
      ]
    ,""
    )
  ,("Expo temporaire du musée des peintres"
    ,"/images/tiles/animation/expoMusée.jpg"
    , [ h5 [] [text "Date: saison estivale"]
      , a [ href "http://www.musee-murol.fr/fr", target "_blank"]
          [ text "site officiel"]
      , p [] [text "Chaque année, le dernier week-end de mai,
                   la commune organise le vernissage d’une 
                   exposition temporaire inédite au musée des Peintres de 
                   l’Ecole de Murols. 
                   L’exposition reste en place jusqu’au 31 octobre. L’objectif 
                   est de regrouper et de présenter pendant quelques 
                   mois les œuvres de l’un des peintres majeurs 
                   de l’Ecole de Murols." ]
      ]
    ,""
    )
  ,("Horizons, Arts nature en Sancy"
    ,"/images/tiles/animation/horizon.jpg"
    , [ h5 [] [text "Date: saison estivale"]
      , a [ href "http://www.horizons-sancy.com", target "_blank"]
          [ text "site officiel"]
      , p [] [text "Cette manifestation culturelle est organisée par la communauté 
                    de communes du massif du Sancy. La commune 
                    de Murol soutient cet événement en tant que 
                    membre de la communauté de communes et a 
                    déjà accueilli de nombreuses œuvres sur son territoire." ]
      , p [] [text "Les œuvres éphémères sont installées de juin à 
                    septembre sur des sites naturels. Cette manifestation prend 
                    une ampleur considérable qui dépasse le cadre régional 
                    et même national. "]
      ]
    ,""
    )
  ,("Fête de la révolution"
    ,"/images/tiles/animation/feu d'artifice.jpg"
    , [ h5 [] [text "Date: 14 juillet"]
      , a [ href "/14Juillet.html" ]
          [ text "lien photothèque"]
      , p [] [text "La municipalité de Murol, en partenariat avec différentes 
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
    ,""
    )
  ,("Festival d'Art"
    ,"/images/tiles/animation/festivalArt.jpg"
    , [ h5 [] [text "Date: été"]
      , a [ href "/FestivalArt.html" ]
          [ text "lien photothèque"]
      , p [] [text "Le service animation de la mairie organise chaque 
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
    ,""
    )
  ,("Animation estivale pour tous"
    ,"/images/tiles/animation/animation estivale.jpg"
    , [  p [] [text "La saison estivale est riche de nombreuses animations!"]
      , p [] [text "Programme du mois de juillet 2018: "]
      
      , a [href "/baseDocumentaire/animation/programme des animations de la vallée verte juillet 2018.pdf", target "_blank"]
          [text "programme animations vallée verte juillet 2018"]
      , br [] []
       , br [] []
      , a [href "/baseDocumentaire/baseDocumentaire/animationsAout2018.pdf", target "_blank"]
          [text "programme animations vallée verte août 2018"]
      , br [] []
      , br [] []
      , img [src "/images/illustration animations estivales.jpg"] []
      ]
    ,""
    ) 
  ]