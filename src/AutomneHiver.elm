module AutomneHiver where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp.Simple as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Lightbox
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

update : Action -> Model -> Model
update action model =
  case action of 
    NoOp -> model
    (LightboxAction n act) ->
      let updateWithId g =
            if (.id g == n)
            then { g | lightbox = Lightbox.update act (.lightbox g) }
            else g  
      in { model | galleries = List.map updateWithId (.galleries model) }

-- View

viewGallery : Signal.Address Action -> Gallery -> Html
viewGallery address {lightbox, id} =
 Lightbox.view (Signal.forwardTo address (LightboxAction id)) lightbox

view : Signal.Address Action -> Model -> Html
view address model =
  div [ id "container"]
      [ renderMainMenu' ["Culture et loisirs", "Phototheque"]
                        (.mainMenu model)
      , div [ id "subContainer"]
            (List.map (viewGallery address) (.galleries model))
      , pageFooter
      ]

--Main

--focusBox = Signal.mailbox ()

--port focus : Signal ()
--port focus = Signal.constant ()

main =
  StartApp.start
    { model  = initialModel
    , view   = view
    , update = update
    }

-- Data

galleries : List Gallery
galleries = [hiver, automne]

automne = 
  let lb =  
        Lightbox.init 
          [ { defPic |
              filename = "001.jpg"
            , legend = Just "So very pretty"
            }
            ,
            { defPic |
              filename = "002.jpg"
            , legend = Just ""
            }
            ,
            { defPic |
              filename = "003.jpg"
            , legend = Just ""
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
          ] "hiver"
  in Gallery lb 0