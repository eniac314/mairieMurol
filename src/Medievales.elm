module Medievales where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp as StartApp
import Effects exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Dict exposing (..)
import Lightbox exposing (Picture, defPic, picList)
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

--defPic = Lightbox.Picture "" Nothing Nothing Nothing

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
        div [ class "subContainerData noSubmenu", id "medievales"]
            (
            [ h2 [] [text "Les Médiévales"] ]
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
galleries = [ (medievales2018, "medievales2018") 
            , (medievales2017, "medievales2017") 
            , (medievales2016, "medievales2016")
            , (medievales2015, "medievales2015")
            , (medievales2014, "medievales2014")
            , (medievales2013, "medievales2013")
            ]

(medievales2013, medievales2013Fx) = 
  Gallery.init (picList 36) "medievales2013" "Les Médiévales 2013"

(medievales2014, medievales2014Fx) = 
  Gallery.init (picList 20) "medievales2014" "Les Médiévales 2014"

(medievales2015, medievales2015Fx) = 
  Gallery.init (picList 16) "medievales2015" "Les Médiévales 2015"

(medievales2016, medievales2016Fx) = 
  Gallery.init (picList 56) "medievales2016" "Les Médiévales 2016"

(medievales2017, medievales2017Fx) = 
  Gallery.init (picList 64) "medievales2017" "Les Médiévales 2017"

(medievales2018, medievales2018Fx) = 
  Gallery.init (picList 84) "medievales2018" "Les Médiévales 2018"
