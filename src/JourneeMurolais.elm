module JourneeMurolais where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp as StartApp
import Effects exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Lightbox exposing (Picture, defPic, picListHD)
import Gallery exposing (..)
import Time exposing (..)
import Task exposing (..)
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

type alias Model = 
  { mainMenu    : Utils.Menu
  , galleries   : List (Gallery.Model,String)
  , debug : String
  }

initialModel =
  { mainMenu  = mainMenu
  , galleries = galleries
  , debug = ""
  }

-- Update

type Action = 
   NoOp 
 | GalleryAction String (Gallery.Action)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of 
    NoOp -> (model,none)
    (GalleryAction name act) ->
      let updateWithId (g,folder) =
            if (folder == name)
            then (Gallery.update act g, folder)
            else ((g,none),folder)

          (ng,effs) = List.foldl (\((g,e),f) (gs,ef) ->
                                   ((g,f)::gs,(Effects.map (GalleryAction f) e)::ef))
                                 ([],[])
                                 (List.map updateWithId (.galleries model))


      in ({ model | galleries = List.reverse ng}
          , Effects.batch effs)


-- View

viewGallery : Signal.Address Action -> (Gallery.Model,String) -> List Html
viewGallery address (gallery, name) =
  let t = h5 [] [text (.descr gallery)]
  in 
  t :: [Gallery.view (Signal.forwardTo address (GalleryAction name)) gallery]
 
view : Signal.Address Action -> Model -> Html
view address model =
  let galleriesHtml = List.concat (List.map (viewGallery address) (.galleries model))
      
      subContainerData =
        div [ class "subContainerData noSubmenu", id "journeeMurolais"]
            (
            [ h2 [] [text "La journée des murolais"] ]
             ++ galleriesHtml ++
            [ a [ href "/Photothèque.html", id "backToTiledMenu"]
                [ text "Revenir au menu" ]
            ]
            )

  in
  div [ id "container"]
      [ renderMainMenu ["Culture et loisirs", "photothèque"]
                        (.mainMenu model)
      , div [ id "subContainer"]
            [ subContainerData ]
      , pageFooter
      ]

--Main

timer g = Signal.map (\_ -> GalleryAction (snd g) Gallery.TimeStep) (every (3*second))

timers = List.map timer galleries


app =
    StartApp.start
          { init = (initialModel, none)
          , view = view
          , update = update
          , inputs = timers
          }

main =
    app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks

-- Data

--galleries : List Gallery
galleries = [(journeeMurolais2016,"journeeMurolais2016")
            ,(journeeMurolais, "journeeMurolais")
            ]

(journeeMurolais2016,journeeMurolais2016FX) = 
  Gallery.init (picListHD 13) "journeeMurolais2016" "Edition 2016"

(journeeMurolais, journeeMurolaisFx) = 
  Gallery.init 
    [ { defPic |
        filename = "escalier 1.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "escalier 2.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "escalier 3.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "escalier 4.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "panorama 1.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "panorama 2.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "panorama 3.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "panorama  4.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "panorama 5.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "panorama 6.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "tribune 1.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "tribune 2.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "tribune 3.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "tribune 4.jpg"
      , caption = Just ""
      , linkHD = True
      }
      ,
      { defPic |
        filename = "tribune 5.jpg"
      , caption = Just ""
      , linkHD = True
      }
    ] "journeeMurolais" "Edition 2015"

