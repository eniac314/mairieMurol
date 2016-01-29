module AutomneHiver where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp as StartApp
import Effects exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Lightbox
import Time exposing (..)
import Murol exposing (mainMenu,
                       renderMainMenu',
                       pageFooter,
                       renderMisc,
                       capitalize,
                       renderListImg,
                       logos,
                       renderSubMenu,
                       mail,
                       site,
                       link)

-- Model

type alias Model = 
  { mainMenu    : Murol.Menu
  , galleries   : List Gallery
  }

type alias Gallery =
  { lightbox : Lightbox.Model
  , id : Int
  }

defPic = Lightbox.Picture "" Nothing Nothing Nothing

initialModel =
  { mainMenu  = mainMenu
  , galleries = galleries
  }

-- Update

type Action = 
   NoOp 
 | LightboxAction Int (Lightbox.Action)

--update : Action -> Model -> Model
update action model =
  case action of 
    NoOp -> (model,none)
    (LightboxAction n act) ->
      let updateWithId g =
            if (.id g == n)
            then { g | lightbox = Lightbox.update act (.lightbox g) }
            else g  
      in ({ model | galleries = List.map updateWithId (.galleries model) },none)

-- View

viewGallery : Signal.Address Action -> Gallery -> Html
viewGallery address {lightbox, id} =
 let lightboxHtml = Lightbox.view (Signal.forwardTo address (LightboxAction id)) lightbox
 in 
 div [class "gallery"]
     [lightboxHtml]

view : Signal.Address Action -> Model -> Html
view address model =
  let galleriesHtml = List.map (viewGallery address) (.galleries model)
      
      subContainerData =
        div [ class "subContainerData noSubmenu", id "automneHiver"]
            (
            [ h2 [] [text "Paysages, automne, hiver"] ]
            ++ galleriesHtml ++
            [ a [ href "/Phototheque.html", id "backToTiledMenu"]
                [ text "Revenir au menu" ]
            ]
            )

  in
  div [ id "container"]
      [ renderMainMenu' ["Culture et loisirs", "Phototheque"]
                        (.mainMenu model)
      , div [ id "subContainer"]
            [ subContainerData ]
      , pageFooter
      ]

--Main

--focusBox = Signal.mailbox ()

--port focus : Signal ()
--port focus = Signal.constant ()

timer = Signal.map (\_ -> LightboxAction 0 Lightbox.Right) (every (3*second))

--main =
--  StartApp.start
--    { model  = initialModel
--    , view   = view
--    , update = update
--    }


app =
    StartApp.start
          { init = (initialModel, none)
          , view = view
          , update = update
          , inputs = [timer]
          }

main =
    app.html

-- Data

galleries : List Gallery
galleries = [automne ,hiver]

automne = 
  let lb =  
        Lightbox.init 
          [ { defPic |
              filename = "002.jpg"
            , legend = Just "Test légende: Paysage d'automne"
            }
            ,
            { defPic |
              filename = "003.jpg"
            , legend = Just ""
            }
            ,
            { defPic |
              filename = "19097479.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "Couzes.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "001.jpg"
            , legend = Just "So very pretty"
            }
            ,
            { defPic |
              filename = "19097479.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "lacAut01.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "lacAut02.jpg"
            ,  legend = Just ""
            }
            
          ] "automne"
  in Gallery lb 1

hiver = 
  let lb =  
        Lightbox.init 
          [ { defPic |
              filename = "100_8732.jpg"
            , legend = Just ""
            }
            ,
            { defPic |
              filename = "100_8733.jpg"
            , legend = Just ""
            }
            ,
            { defPic |
              filename = "100_8734.jpg"
            , legend = Just ""
            }
            ,
            { defPic |
              filename = "100_8742.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "1670-8.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "32285740.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "©-azureva_murol-tourisme-hiver.jpg"
            ,  legend = Just ""
            }
            ,
            { defPic |
              filename = "pt12969.jpg"
            ,  legend = Just ""
            }
          ] "hiver"
  in Gallery lb 0