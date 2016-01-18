module SideMenu where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Dict exposing (..)

-- Model

type alias Model = 
  { current  : ContentType
  , menuData : Dict ID (Tile,Html)
  }