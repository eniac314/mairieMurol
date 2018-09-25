module Annee2018 where

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
        div [ class "subContainerData noSubmenu", id "annee2018"]
            (
            [ h2 [] [text "l'année 2018"] ]
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
galleries = [ (terreEauDeLaPaix2018, "TerreEauDeLaPaix2018")
            , (tropheeEdf, "tropheeEdf")
            , (rentreeMusique2018, "rentreeMusique2018")
            , (voeuxMaireEtCCAS2018, "voeuxMaireEtCCAS2018")
            ]

( terreEauDeLaPaix2018, terreEauDeLaPaix2018FX ) =
    Gallery.init (picList 28) "TerreEauDeLaPaix2018" "22 et 23 septembre - Performances dansées Terre-eau de la Paix"

( tropheeEdf, tropheeEdfFX ) = 
  Gallery.init (picList 10) "tropheeEdf" "19 septembre - La cérémonie de remise du trophée EDF"

( voeuxMaireEtCCAS2018, voeuxMaireEtCCAS2018FX ) = 
  Gallery.init (picList 21) "voeuxMaireEtCCAS2018" "21 janvier - Les voeux du maire"

(rentreeMusique2018, rentreeMusique2018FX) = 
  Gallery.init (picList 6) "rentreeMusique2018" "3 septembre - La rentrée en musique"  

