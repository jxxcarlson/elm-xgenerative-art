module Day1 exposing (main)

{- This is a starter app which presents a text label, text field, and a button.
   What you enter in the text field is echoed in the label.  When you press the
   button, the text in the label is reverse.
   This version uses `mdgriffith/elm-ui` for the view functions.
-}

import Browser
import Html exposing (Html)
import Color
import TypedSvg exposing (circle, svg)
import TypedSvg.Attributes exposing (cx, cy, fill, r, width, height, stroke, strokeWidth, viewBox)
import TypedSvg.Types exposing (Fill(..), px)
import Shape exposing (render, renderGradientShape, Kind(..))


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    {}


type Msg
    = NoOp


type alias Model =
    { count : Int }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { count = 0 }
    , Cmd.none
    )


subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        b =
            Shape.basic
    in
        svg
            -- [ viewBox 0 0 300 300 ]
            [ width (px 600), height (px 600) ]
        <|
            [ render { b | kind = Square, cx = 300, cy = 300, r = 600, s = 0, l = 0.2 }
            , render { b | cy = 300, cx = 60 }
            , render { b | cy = 500, cx = 180, r = 40, a = 0.5 }
            , render { b | kind = Circle, cx = 500, cy = 150, r = 60, h = 0.1 }
            , render { b | kind = Circle, cx = 580, cy = 550, r = 60, h = 0.1, a = 0.25 }
            ]
                ++ (renderGradientShape { b | kind = Circle, cx = 400, cy = 300, r = 180 } 10 0.5 0.2)
                ++ (renderGradientShape { b | kind = Circle, h = 0.5, cx = 80, cy = 50, r = 270 } 20 0.3 0.1)
                ++ (renderGradientShape { b | kind = Square, h = 0.7, cx = 40, cy = 510, r = 340 } 10 0.3 0.05)
