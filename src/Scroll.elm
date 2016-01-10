module Scroll (scrollY)where


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Effects exposing (..)
import StartApp as StartApp
import List exposing (..)
import String exposing (words, join, cons, uncons)
import Char
import Task
import Date exposing (..)


scrollYInbox : Signal.Mailbox String
scrollYInbox = Signal.mailbox "5"

--scrollYEvent = on "scrollY" targetValue
--                (\s -> Signal.message scrollYInbox.address s)

--messages = scrollYInbox.signal

port scrollY : Signal Int

