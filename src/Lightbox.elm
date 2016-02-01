module Lightbox (Picture, Model, Action(..), init, update, view)where

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
     , display : Bool
     , diaporama : Bool
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
  in Model (biStream pics defPic) nameList folder False False

-- Update
type Action = 
   NoOp
 | Left
 | Right
 | Display
 | Close
 | GoTo String
 | TimeStep
 | Diaporama
 | OpenDiapo

update : Action -> Model -> Model
update action model =
  case action of 
    NoOp      -> model
    Left      -> { model | pictures  = left (.pictures model) }
    Right     -> { model | pictures  = right (.pictures model) }
    Display   -> { model | display   = not (.display model) }
    Close     -> { model | display   = False } 
    Diaporama -> { model | diaporama = not (.diaporama model) }
    OpenDiapo -> { model | diaporama = True, display = True }
    GoTo n    -> { model |
                   pictures = goTo (.pictures model) (\p -> (.filename p) == n)
                 , display  = True
                 }
    TimeStep   -> { model | pictures = if (.diaporama model)
                                       then right (.pictures model)
                                       else (.pictures model)
                  }



-- View
thumbs : Signal.Address Action -> Model -> Html
thumbs address model = 
  let nameList = .nameList model

      thumb n  =
        a [ onClick address (GoTo n)
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
  div [ classList [("lightbox",True),("display",(.display model))]
      , onKey address, tabindex 0, autofocus True
      ]
      [ div [ class "lightbox-content"
            , onKey address, tabindex 0, autofocus True
            ]
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
                  , a [ id "closebtn"
                      , class "noselect"
                      , onClick address Display
                      ] [i [class "fa fa-times"] []]
                  , a [ id "diapoLightbox"
                      , class "noselect"
                      , onClick address Diaporama
                      ] [ (if (.diaporama model)
                          then i [class "fa fa-pause"] []
                          else i [class "fa fa-play" ] [])
                         ]
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
        else if key == 27
        then Close
        else NoOp
  in onKeyDown address keyToAct


view : Signal.Address Action -> Model -> Html
view address model =
  div []
      [ thumbs address model
      , lightbox address model
      ]


myStyle = 
  style [ ("animation", "fadein 2s")
        ] 