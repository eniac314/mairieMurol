module Gallery (Picture) where

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
     { pictures : BiStream Picture
     , nameList : List String
     , folder : String
     }

type alias Picture = Lightbox.Picture

-- Update

-- View

