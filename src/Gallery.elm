module Gallery ( Picture
               , Action(TimeStep)
               , Model
               , init
               , update
               , view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Dict exposing (..)
import Date exposing (..)
import Streams exposing (..)
import Lightbox

-- Model
type alias Model = 
     { pictures : BiStream (List Picture)
     , lightbox : Lightbox.Model
     , diaporama : Bool
     , unfold : Bool
     , folder : String
     , descr : String
     }

type alias Picture = Lightbox.Picture

init : List Picture -> String -> String -> Model
init pics folder descr = 
  let pictures  = biStream (chunk 4 pics) []
      lightbox  = Lightbox.init pics folder
      diaporama = False
      unfold    = False
  in Model pictures lightbox diaporama unfold folder descr

-- Update

type Action = 
      Up 
    | Down
    | Unfold
    | Diaporama
    | TimeStep
    | LightboxAction Lightbox.Action


update : Action -> Model -> Model 
update action model = 
  case action of 
    Up        -> { model | pictures = left (.pictures model) }
    
    Down      -> { model | pictures = right (.pictures model) }
    
    Unfold    -> { model | unfold = not (.unfold model) }
    
    Diaporama -> { model | diaporama = not (.diaporama model) }
    
    TimeStep -> { model 
                | pictures = if (.diaporama model)
                             then right (.pictures model)
                             else (.pictures model)

                , lightbox = Lightbox.update Lightbox.TimeStep (.lightbox model)
                }
    
    LightboxAction act -> { model
                          | lightbox = Lightbox.update act (.lightbox model)
                          }


-- View
renderPreview : Signal.Address Action -> Model -> Html
renderPreview address model = 
  let thumb p  =
        a [ onClick address (LightboxAction (Lightbox.GoTo (.filename p)))
          ]
          [ img [src ("images/phototheque/" 
                       ++ (.folder model)
                       ++ "/thumbs/"
                       ++ (.filename p))
                ] []
          ]

      thumbs = List.map thumb (current (.pictures model))

  in div [ class "previewPanel"]
         [ div [ class "previewThumbs"] thumbs
         , div [ class "galleryButtons"]
               [ button [ onClick address Up] [ text "Suivant" ]
               , button [ onClick address Down] [ text "Précédent" ]
               , button [ onClick address Diaporama]
                        [ if (.diaporama model)
                          then text "Arret"
                          else text "Défiler"
                        ]
               ]
         ] 

view : Signal.Address Action -> Model -> Html
view address model = 
  div [ class "gallery" ]
      [ renderPreview address model
      , button [ onClick address Unfold, class "seeAll"]
               [ text "Voir toutes les photos"]
      , div [ class "galleryDescr"] [text (.descr model)]
      , div [ classList [("galleryLightbox", True),("display", (.unfold model))]]
            [ Lightbox.view (Signal.forwardTo address LightboxAction) (.lightbox model)]
      ]



-- Utils
chunk : Int -> List a -> List (List a)
chunk n xs = 
  case xs of 
    []  -> []
    xs' -> (List.take n xs') :: chunk n (drop n xs')


