module Gallery ( Picture
               , Action(TimeStep,Focused)
               , Model
               , MiniGallery
               , init
               , update
               , view
               , initMiniGallery
               , updateM
               , viewM
               , chunk3 ) where

import StartApp as StartApp
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Easing exposing (..)
import Effects exposing (Effects,none)
import Json.Decode as Json exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Dict exposing (..)
import Date exposing (..)
import Streams exposing (..)
import Lightbox
import ListOfPics exposing (picList, picList2)
import Utils exposing (shuffle)
import Time exposing (Time,second)

-- Model
type alias Model = 
     { pictures : BiStream (List Picture)
     , lightbox : Lightbox.Model
     , direct : Direction
     , moving : Bool
     , unfold : Bool
     , diaporama : Bool
     , folder : String
     , descr : String
     , animationState : AnimationState
     }

type alias MiniGallery = 
     { pictures : BiStream (List Thumbnail)
     , direct : Direction
     , animationState : AnimationState
     , moving : Bool
     , focused : Bool
     }

type alias Thumbnail = 
     { filename : String
     , folder : String
     , ref : String
     }

type alias Picture = Lightbox.Picture

type Direction = Left | Right

type alias AnimationState =
    Maybe { prevClockTime : Time, elapsedTime : Time }


init : List Picture -> String -> String -> (Model, Effects Action)
init pics folder descr = 
  let pictures  = biStream (chunk3 6 pics Lightbox.defPic) []
      lightbox  = Lightbox.init pics folder
      moving    = False
      unfold    = False
      diaporama = False
  in ( Model pictures lightbox Left moving unfold diaporama folder descr Nothing
     , Effects.none ) 

initMiniGallery : Int -> (MiniGallery, Effects Action)
initMiniGallery seed = 
  let thumbs = List.map (\(a,b,c) -> Thumbnail a b c) picList2
      picStream = biStream (chunk3 3 (List.take 20 (shuffle thumbs seed)) (Thumbnail "" "" "")) []

  in (MiniGallery picStream Left Nothing True True, Effects.none)


duration  = 1*Time.second

maxOffset = 224


-- Update

type Action = 
      Unfold
    | Moving
    | Focused Bool
    | TimeStep
    | LightboxAction Lightbox.Action
    | MoveLeft
    | MoveRight
    | Tick Direction Time.Time
    | Diaporama



update : Action -> Model -> (Model, Effects Action) 
update action model = 
  case action of 
    
    Diaporama -> ({ model | lightbox =
                              Lightbox.update Lightbox.OpenDiapo (.lightbox model)}
                 , none)

    Unfold    -> ({ model | unfold = not (.unfold model) },none)
    
    Moving    -> ({ model | moving = not (.moving model) },none)

    Focused b -> ({ model | moving = b },none)

    
    TimeStep -> ({ model 
                 | lightbox = Lightbox.update Lightbox.TimeStep (.lightbox model)
                 , direct = if (.moving model)
                            then Right
                            else (.direct model)
                 }, if (.moving model)
                    then Effects.tick (Tick Right)
                    else none)
    
    LightboxAction act -> ({ model
                           | lightbox = Lightbox.update act (.lightbox model)
                           }, none)

    MoveLeft -> 
      case model.animationState of
        Nothing ->
          ( { model | direct = Left }
          , Effects.tick (Tick Left) )

        Just _ ->
          ( model, Effects.none )

    MoveRight -> 
      case model.animationState of
        Nothing ->
          ( { model | direct = Right }
          , Effects.tick (Tick Right) )

        Just _ ->
          ( model, Effects.none )
    
    
    Tick direct clockTime ->
      let
        newElapsedTime =
          case model.animationState of
            Nothing ->
              0

            Just {elapsedTime, prevClockTime} ->
              elapsedTime + (clockTime - prevClockTime)
      in
        if newElapsedTime > duration then
          ( { model | pictures = 
                        case direct of 
                          Right -> right (.pictures model)
                          Left  -> left  (.pictures model)
            , animationState = Nothing
            }
          , Effects.none
          )
        else
          ( { model | 
              animationState =
               Just { elapsedTime = newElapsedTime, prevClockTime = clockTime }
            }
          , Effects.tick (Tick direct)
          )

updateM  : Action -> MiniGallery -> (MiniGallery, Effects Action) 
updateM action model = 
  case action of 
    Diaporama -> (model,none)
    Unfold    -> (model,none)
    Moving    -> ({ model | moving = not (.moving model)},none)
    Focused b -> ({ model | focused = b },none)
    TimeStep  -> ({ model 
                  | direct = if (.moving model )
                             then Right
                             else (.direct model)
                  }, if (.moving model && .focused model)
                     then Effects.tick (Tick Right)
                     else none)
    LightboxAction act -> (model,none)
    MoveLeft -> 
      case model.animationState of
        Nothing ->
          ( { model | direct = Left }
          , Effects.tick (Tick Left) )

        Just _ ->
          ( model, Effects.none )

    MoveRight -> 
      case model.animationState of
        Nothing ->
          ( { model | direct = Right }
          , Effects.tick (Tick Right) )

        Just _ ->
          ( model, Effects.none )
    
    
    Tick direct clockTime ->
      let
        newElapsedTime =
          case model.animationState of
            Nothing ->
              0

            Just {elapsedTime, prevClockTime} ->
              elapsedTime + (clockTime - prevClockTime)
      in
        if newElapsedTime > duration then
          ( { model | pictures = 
                        case direct of 
                          Right -> right (.pictures model)
                          Left  -> left  (.pictures model)
            , animationState = Nothing
            }
          , Effects.none
          )
        else
          ( { model | 
              animationState =
               Just { elapsedTime = newElapsedTime, prevClockTime = clockTime }
            }
          , Effects.tick (Tick direct)
          )


-- View


toOffset : AnimationState -> Float
toOffset animationState =
  case animationState of
    Nothing ->
      0

    Just {elapsedTime} ->
      ease easeOutSine Easing.float 0 maxOffset duration elapsedTime


renderPreview : Signal.Address Action -> Model -> Html
renderPreview address model = 
  let thumb p  =
        a [ onClick address (LightboxAction (Lightbox.GoTo (.filename p)))
          , offset ((if (.direct model) == Left then 1 else -1) * toOffset (.animationState model))
          ]
          [ img [src ("images/photothèque/" 
                       ++ (.folder model)
                       ++ "/thumbs/"
                       ++ (.filename p))
                ] []
          ]

      thumbs = List.map thumb (current (.pictures model))

  in div [ class "previewPanel"]
         [ div [ class "previewThumbs"] [div [class "innerPannel"] thumbs]
         
         ] 

view : Signal.Address Action -> Model -> Html
view address model = 
  div [ class "gallery" ]
      [ renderPreview address model
      , div [ class "galleryButtons"]
               [ div [class "seeAll"]
                     [button [ onClick address Unfold]
                             [ text "Voir toutes les photos"]
                     ]               
               , button [ onClick address MoveLeft] [i [class "fa fa-backward"] []]
               , button [ onClick address Moving]
                        [ if (.moving model)
                          then i [class "fa fa-pause"] []
                          else i [class "fa fa-play" ] [] 
                        ]
               , button [ onClick address MoveRight] [i [class "fa fa-forward"] []]
               
               , button [ onClick address Diaporama
                        , class "diapoButton"
                        ] [text "Diaporama"]
               ]
      , div [ classList [("galleryLightbox", True),("display", (.unfold model))]]
            [ Lightbox.view (Signal.forwardTo address LightboxAction) (.lightbox model)]
      ]

viewM : Signal.Address Action -> MiniGallery -> Html
viewM address model = 
  let thumb p  =
        a [ offset ((if (.direct model) == Left then 1 else -1) * toOffset (.animationState model))
          ]
          [ img [src ("images/photothèque/" 
                       ++ (.folder p)
                       ++ "/thumbs/"
                       ++ (.filename p))
                --, style [("width","260px")
                        --,("","")
                        --]
                ] []
          , div [ class "hiddenGalleryLinksContainer"]
                [ a [ href (.ref p)
                    , class "hiddenGalleryLinks"
                    ]
                    [text "Voir la galerie"]
                , a [ href "/photothèque.html"
                    , class "hiddenGalleryLinks"
                    ]
                    [text "Visiter la photothèque"]
                ]
          ]

      thumbs = List.map thumb (current (.pictures model))
  in 
  div [ class "gallery" , id "miniGallery", style [("width","280px")]]
      [ div [ class "previewPanel", style [("width","230px")]]
            [ div [ class "previewThumbs"] [div [class "innerPannel"] thumbs]
         
            ]
      , div [ class "galleryButtons" , style [("text-align","center"),("margin","auto")]]
                            
            [ button [ onClick address MoveLeft] [i [class "fa fa-backward"] []]
            , button [ onClick address Moving]
                     [ if (.moving model)
                       then i [class "fa fa-pause"] []
                       else i [class "fa fa-play" ] [] 
                     ]
            , button [ onClick address MoveRight] [i [class "fa fa-forward"] []]
               
            ]
      ]

-- Utils
chunk : Int -> List a -> List (List a)
chunk n xs = 
  case xs of 
    []  -> []
    xs' -> (List.take n xs') :: chunk n (drop n xs')


chunk2 : Int -> List a -> List (List a)
chunk2 n xs = 
  case xs of 
    []       -> []
    (x::xs') -> 
      let ch  = List.take n (x::xs')
          l   = List.length ch
      in if  l < n
         then [ ch ++ List.reverse ((List.take (n-l) (List.reverse xs))) ]
         else ch :: (chunk2 n xs') 


chunk3 : Int -> List a -> a -> List (List a)
chunk3 n xs def = 
  let str = Streams.cycle xs def
      takeAndRotate acc m s = 
        if m == 0 then acc
        else takeAndRotate (Streams.toList s n :: acc) (m-1) (snd (next s))
        in List.reverse (takeAndRotate [] (List.length xs) str) 



myStyle = 
  style [ ("animation", "fadein 2s")
        ]

offset x = 
  style [ ("transform", "translateX(" ++ toString x ++ "px)")
        ]

