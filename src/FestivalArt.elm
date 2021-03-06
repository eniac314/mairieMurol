module FestivalArt where

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
        div [ class "subContainerData noSubmenu", id "festivalArt"]
            (
            [ h2 [] [text "Le festival d'Art"] ]
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
galleries = [(festival2018, "festival2018")
            ,(festival2017, "festival2017")
            ,(festival2016, "festival2016")
            ,(festival, "festival")
            ]

(festival2018, festival2018Fx) = 
  Gallery.init (picList 98) "festivalArt2018" "Festival d'Art 2018"

(festival2017, festival2017Fx) = 
  Gallery.init (picList 88) "festivalArt2017" "Festival d'Art 2017"

(festival2016, festival2016Fx) = 
  Gallery.init (picList 88) "festivalArt2016" "Festival d'Art 2016"

(festival, festivalFx) = 
  Gallery.init 
    [ { defPic |
        filename = "1 Le maire et les organisatrices.jpg"
      , caption = Just "Le maire et les organisatrices"
      }
      ,
      { defPic |
        filename = "2A  place de l'église.jpg"
      , caption = Just "Place de l'église"
      }
      ,
      { defPic |
        filename = "2B Animation sur la place de l'église.jpg"
      , caption = Just "Animation sur la place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 1.jpg"
      , caption = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 2.jpg"
      , caption = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 3.jpg"
      , caption = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 4.jpg"
      , caption = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la salle des fêtes.jpg"
      , caption = Just "Stand place de la salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 10.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 11.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 12.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 1.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 2.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 3.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 4.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 5.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 6.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 7.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 8.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 9.jpg"
      , caption = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 2.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 3.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 4.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 5.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 6.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 7.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 8.jpg"
      , caption = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 10.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 2.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 3.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 4.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 5.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 7.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 8.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 9.jpg"
      , caption = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 1.jpg"
      , caption = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 2.jpg"
      , caption = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 3.jpg"
      , caption = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 4.jpg"
      , caption = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou  1 rue George Sand.jpg"
      , caption = Just "La compagnie Lilou rue George Sand"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de la poste.jpg"
      , caption = Just "La compagnie Lilou place de la poste"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de la salle des fêtes 1.jpg"
      , caption = Just "La compagnie Lilou place de la salle des fêtes"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de la salle des fêtes 2.jpg"
      , caption = Just "La compagnie Lilou place de la salle des fêtes"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de l'église.jpg"
      , caption = Just "La compagnie Lilou place de l'église"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou Z1.jpg"
      , caption = Just "La compagnie Lilou"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou Z2.jpg"
      , caption = Just "La compagnie Lilou"
      }
      ,
      { defPic |
        filename = "Les Piplettes en concert de clôture.jpg"
      , caption = Just "Les Piplettes en concert de clôture"
      }
    ] "festivalArt" "Festival d'Art 2015"

