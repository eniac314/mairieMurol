module Artistes where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Murol exposing (mainMenu,
                       renderMainMenu,
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       Action (..),
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model
subMenu = []

initialModel =
  { mainMenu    = mainMenu
  , subMenu     = subMenu
  , mainContent = initialContent
  }


type alias Entry = (String,String)


-- View
view address model =
  div [ id "container"]
      [ renderMainMenu address ["Culture et loisirs", "Artistes"]
                               (.mainMenu model)
      , div [ id "subContainer"]
            [ .mainContent model
            ]
      , pageFooter
      ]



contentMap =
 fromList []

update action model =
  case action of
    NoOp    -> model
    Entry s -> changeMain model s
    _       -> model

changeMain model s =
    let newContent = get s contentMap
    in case newContent of
        Nothing -> model
        Just c  -> { model | mainContent = c }

--Main

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

initialContent =
  div [ class "subContainerData noSubmenu", id "artistes"]
      [ h2 [] [text "Artistes Murolais"]
      , p  [] [ text "Murol est source d’inspiration ! "]
      , p  [] [ text "De nombreux artistes et artisans d’art y sont 
                     nés ou s’y sont installés. Leurs passions sont 
                     très diverses : peinture, sculpture, musique, couture, littérature… 
                     Ils travaillent le cuir, le fer, le bois… "]
      , p  [] [ text "Pour les découvrir, suivez les liens en cliquant 
                     sur leurs noms. La plupart des liens conduit 
                     sur le site "
              , a [href "http://www.murol-terre-des-arts.wifeo.com", target "_blank"]
                  [text "www.murol-terre-des-arts.wifeo.com"]
              , text " qui présente également des 
                      artistes des environs de Murol. "
              ]
      , p [] [text "Allez le voir ! "]
      , p [] [text "Les artistes de Murol et d’ailleurs ont maintenant 
                    leur festival à Murol : "]
      , p [style [("text-align","center")]] [b [] [text "Le festival d’Art "]]
      , p [] [text "Ce festival regroupe de très nombreux artistes et 
                   artisans d’art venus de tous horizons dont les 
                   œuvres envahissent les rues et places de Murol 
                   durant une journée d’été riche en couleurs. Petits 
                   et grands déambulent accompagnés par les animations de 
                   rue jusqu’au soir où ils peuvent partager l’ambiance 
                   festive du concert de clôture. "]

      , div []
            [ p [style [("text-align","center")]] [text "Festival d’Art 2016 : dimanche 31 juillet "]
            , p [style [("text-align","center")]] [text "Pour vous inscrire, contactez la mairie au 04 
                          73 88 60 67 ou par mail à "]
            , p [style [("text-align","center")]] [text "murolanimation@orange.fr"]
            ]

      , a [href "/FestivalArt.html"] [text "Lien avec la photothèque!"]     

      , div [ class "artiste"]
            [ h5  [] [text "Marie ABDESSELAM : création de figurines…"]
            , img [src "/images/artistes/Entete-Marie.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/marie-magnaval.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Danielle BESSE : aérographe, dessin, peinture…"]
            , img [src "/images/artistes/FresqueA-2012.jpg"] []
            , a   [target "_blank", href "http://daniellaero.wifeo.com/"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Fabienne LAVEDRINE (atelier HOTANTIK BY FAB) : ferronnerie d’Art, sculpture"]
            , img [src "/images/artistes/lavedrine1.jpg"] []
            --, img [src "/images/artistes/lavedrine2.jpg"] []
            --, img [src "/images/artistes/lavedrine3.jpg"] []
            --, img [src "/images/artistes/lavedrine4.jpg"] []
            , a   [target "_blank", href "http://www.hotantikbyfab.fr/"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Annie DUMONTEL : couture, création de costumes"]
            , img [src "/images/artistes/image3.jpg"] []
            --, img [src "/images/artistes/image4.jpg"] []
            , a   [target "_blank", href "/baseDocumentaire/L'atelier couture.pdf"]
                  [text "l’atelier couture"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Claire GOUTTEBEL : création de mini vitrines artisanales"]
            , img [src "/images/artistes/Claire-Gouttebel.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/claire-gouttebel.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Marc HUMBERT : artisan d’Art, travaille le cuir"]
            , img [src "/images/artistes/image7.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/marc-humbert.php"]
                  [text "site officiel 1"]
            , br [] []
            , a   [target "_blank", href "http://www.marc-humbert-cuir.com/acc"]
                  [text "site officiel 2"]  
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Alice JUAN : peinture"]
            , img [src "/images/artistes/image8.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/alice-juan.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Cathy MAURY : peinture, sculpture…"]
            , img [src "/images/artistes/image9.jpg"] []
            --, img [src "/images/artistes/image10.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/cathy-maury.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Berny MEALLET : sculpture sur bois"]
            , img [src "/images/artistes/image11.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/berny-meallet.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Gérard PEUCH :  poésie, peinture…"]
            , img [src "/images/artistes/image12.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/gerard-peuch.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Rudolf SCHÖN : violoniste, pianiste…."]
            , img [src "/images/artistes/image13.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/rudolf-schon.php"]
                  [text "site officiel"] 
            ]
      , div [ class "artiste"]
            [ h5  [] [text "Olivier SIMON : sculpture sur bois"]
            , img [src "/images/artistes/image14.jpg"] []
            , a   [target "_blank", href "http://murol-terre-des-arts.wifeo.com/olivier-simon.php"]
                  [text "site officiel"] 
            ]
      , contact       
      --, h5 [] [text "Site Internet gratuit des \"Artistes Murolais Contemporains\":" ]
      --, p  [] [text "Danielle lance l'idée d'un Site Internet gratuit des \"Artistes Murolais Contemporains\""]
      --, p  [] [text "Peinture, dessin, poésie, sculpture, artisanat d'art, etc....."]
      --, p  [] [text "vous êtes intéressés, contactez-la en utilisant les lien ci-dessous"]
      --, p  [] [link "http://murol-terre-des-arts.wifeo.com" " http://murol-terre-des-arts.wifeo.com"]
      --, p  [] [link "http://murolpoesicales.wifeo.com" "http://murolpoesicales.wifeo.com"]
      --, p  [] [link "http://daniellaero.wifeo.com" "http://daniellaero.wifeo.com"]


      --, h5 [] [text "Cath Cuir: "]
      --, p  [] [text "Rue de Chabrol 63790 MUROL"]
      --, p  [] [text "Tel: 0611891452"]
      --, p  [] [text "Ouvert de juin à août "] 

      --, h4 [] [text "Création d'un orchestre"]
      --, p  [] [text "Madame Marie-Laure Franc, chef d'orchestre, cherche des musiciens pour créer un orchestre dans notre région."]
      --, p  [] [text "Je suis chef d'orchestre et je cherche des 
      --               musiciens pour créer un orchestre dans notre région. 
      --               Le projet est de faire quelques concerts par 
      --               an en soutien aux associations humanitaires. Je fais 
      --               ça à titre bénévole, ne demande aucune participation 
      --               financière, mais simplement musicale dans une ambiance conviviale, 
      --               pour développer les activités artistiques dans notre région. 
      --               N'hésitez pas à me contacter quel que soit 
      --               votre instrument et niveau. "]
      --, p  [] [text "Contact :"]
      --, p  [] [text "Tel: 06 13 39 33 01"]
      --, mail "mariefranc@orange.fr"

      ]
 
contact = 
   p []
     [ text "Liste non exhaustive, contactez "
     , a [href ("mailto:"++"contactsite.murol@orange.fr")]
         [text "le webmaster"]
     , text " pour toute erreur ou oubli!"
     ]