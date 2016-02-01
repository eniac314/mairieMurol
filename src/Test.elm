module Test where

import Html exposing (..)
import Html.Events exposing (..)
import StartApp as StartApp
import Effects exposing (..)
import Time exposing (..) 
import Task exposing (..)

type alias Model =
 {debug : String}

type Action = 
 Start | Tick Time

initialModel = Model "initial"

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Start  -> ({model | debug = "started"}, Effects.tick Tick)
    Tick _ -> ({model | debug = "hasTicked"}, Effects.none)

view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ button [onClick address Start] [text "start"]
      , p [] [text (.debug model)]
      ]

app =
    StartApp.start
          { init = (initialModel, Effects.none)
          , view = view
          , update = update
          , inputs = []
          }

main =
    app.html


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks