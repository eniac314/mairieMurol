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

viewGallery : Signal.Address Action -> (Gallery.Model,String) -> Html
viewGallery address (gallery, name) =
  Gallery.view (Signal.forwardTo address (GalleryAction name)) gallery
 
view : Signal.Address Action -> Model -> Html
view address model =
  let galleriesHtml = List.map (viewGallery address) (.galleries model)
      
      subContainerData =
        div [ class "subContainerData noSubmenu", id "festivalArt"]
            (
            [ h2 [] [text "Le festival d'Art"] ]
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
galleries = [(festival, "festival")]

(festival, festivalFx) = 
  Gallery.init 
    [ { defPic |
        filename = "1 Le maire et les organisatrices.jpg"
      , legend = Just "Le maire et les organisatrices"
      }
      ,
      { defPic |
        filename = "2A  place de l'église.jpg"
      , legend = Just "Place de l'église"
      }
      ,
      { defPic |
        filename = "2B Animation sur la place de l'église.jpg"
      , legend = Just "Animation sur la place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 1.jpg"
      , legend = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 2.jpg"
      , legend = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 3.jpg"
      , legend = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la poste 4.jpg"
      , legend = Just "Stand place de la poste"
      }
      ,
      { defPic |
        filename = "3 stand place de la salle des fêtes.jpg"
      , legend = Just "Stand place de la salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 10.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 11.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 12.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 1.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 2.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 3.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 4.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 5.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 6.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 7.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 8.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand place de l'église 9.jpg"
      , legend = Just "Stand place de l'église"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 2.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 3.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 4.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 5.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 6.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 7.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue Chabrol 8.jpg"
      , legend = Just "Stand rue Chabrol"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 10.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 2.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 3.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 4.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 5.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 7.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 8.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand rue George Sand 9.jpg"
      , legend = Just "Stand rue George Sand"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 1.jpg"
      , legend = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 2.jpg"
      , legend = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 3.jpg"
      , legend = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "3 stand salle des fêtes 4.jpg"
      , legend = Just "Stand salle des fêtes"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou  1 rue George Sand.jpg"
      , legend = Just "La compagnie Lilou rue George Sand"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de la poste.jpg"
      , legend = Just "La compagnie Lilou place de la poste"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de la salle des fêtes 1.jpg"
      , legend = Just "La compagnie Lilou place de la salle des fêtes"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de la salle des fêtes 2.jpg"
      , legend = Just "La compagnie Lilou place de la salle des fêtes"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou place de l'église.jpg"
      , legend = Just "La compagnie Lilou place de l'église"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou Z1.jpg"
      , legend = Just "La compagnie Lilou"
      }
      ,
      { defPic |
        filename = "La compagnie Lilou Z2.jpg"
      , legend = Just "La compagnie Lilou"
      }
      ,
      { defPic |
        filename = "Les Piplettes en concert de clôture.jpg"
      , legend = Just "Les Piplettes en concert de clôture"
      }
    ] "festivalArt" ""

