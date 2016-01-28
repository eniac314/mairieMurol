module Lightbox (Picture, Model, Action, init, update, view)where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Dict exposing (..)
import Date exposing (..)
import Streams exposing (..)

-- Model
type alias Model = 
     { pictures : BiStream Picture
     , nameList : List String
     , folder : String
     }

type alias Picture = 
    { filename : String
    , author : Maybe String
    , date : Maybe Date  
    , legend : Maybe String
    }

defPic : Picture
defPic = Picture "" Nothing Nothing Nothing

init : List Picture -> String -> Model
init pics folder = 
  let nameList = List.map .filename pics
  in Model (biStream pics defPic) nameList folder

-- Update
type Action = 
   NoOp
 | Left
 | Right
 | GoTo String

update : Action -> Model -> Model
update action model =
  case action of 
    NoOp -> model
    Left  -> { model | pictures = left (.pictures model) }
    Right -> { model | pictures = right (.pictures model) }
    GoTo n -> { model | pictures = goTo (.pictures model) (\p -> (.filename p) == n) } 


-- View
thumbs : Signal.Address Action -> Model -> Html
thumbs address model = 
  let nameList = .nameList model

      thumb n  =
        a [ href ("#openLightbox-" ++ (.folder model))
          , onClick address (GoTo n)
          ]
          [ img [src ("images/phototheque/" 
                       ++ (.folder model)
                       ++ "/thumbs/"
                       ++ n)
                ] []
          ]
  in div [class "thumbs"] (List.map thumb nameList)

lightbox : Signal.Address Action -> Model -> Html
lightbox address model = 
  let currentPic = current (.pictures model)
  in 
  div [id ("openLightbox-" ++ (.folder model)), class "lightbox"]
      [ div [class "lightbox-content", onKey address, tabindex 0, autofocus True]
            [ div [ class "picContainer"]
                  [ img [src ("images/phototheque/" 
                             ++ (.folder model) ++ "/"
                             ++ (.filename currentPic))
                        ] []
                  , div [ class "halfPic"
                        , id "halfPicleft"
                        , onClick address Left
                        ] [span [class "noselect"] [text "<<"]]
                  , div [ class "halfPic"
                        , id "halfPicright"
                        , onClick address Right
                        ] [span [class "noselect"] [text ">>"]]
                  ]

            , div [ class "lightBoxlegend"]
                  [ --text "photo " ++ () ++ " sur " () ++ ""
                    text (Maybe.withDefault "" (.legend currentPic))
                  , a [href "#", id "closebtn", class "noselect"] [text "x"]
                  ]
            ]
      ]

onKey : Signal.Address Action -> Attribute
onKey address = 
  let keyToAct key = 
        if (key == 13) || (key == 39)
        then Right
        else if key == 37
        then Left
        else NoOp
  in onKeyDown address keyToAct


view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ thumbs address model
      , lightbox address model
      ]





