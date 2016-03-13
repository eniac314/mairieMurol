module Annee2016 where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp as StartApp
import Effects exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Lightbox exposing (Picture, defPic)
import Gallery exposing (..)
import Time exposing (..)
import Task exposing (..)
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
        div [ class "subContainerData noSubmenu", id "annee2016"]
            (
            [ h2 [] [text "l'année 2016"] ]
             ++ galleriesHtml ++
            [ a [ href "/Photothèque.html", id "backToTiledMenu"]
                [ text "Revenir au menu" ]
            ]
            )

  in
  div [ id "container"]
      [ renderMainMenu' ["Culture et loisirs", "photothèque"]
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
galleries = [(veuxMaireRepasCCAS, "veuxMaireRepasCCAS")]

(veuxMaireRepasCCAS, veuxMaireRepasCCASFx) = 
  Gallery.init 
    [ { defPic |
        filename = "IMGP5755.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5757.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5758.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5759.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5760.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5761.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5763.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5764.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5766.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5767.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5768.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5769.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5770.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5771.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5772.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5773.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5774.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5777.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5778.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5779.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5780.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5781.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5782.jpg"
      , caption = Just ""
      }
      ,
      { defPic |
        filename = "IMGP5783.jpg"
      , caption = Just ""
      }
    ] "veuxMaireRepasCCAS" "24 janvier - vœux du maire et repas CCAS"

