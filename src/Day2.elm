module Day2 exposing (main)

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
import Time
import Shape
    exposing
        ( render
        , renderGradientShape
        , renderList
        , Shape
        , Kind(..)
        , RenderType(..)
        )


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
    | Tick Time.Posix


type alias Model =
    { count : Int, shapeList : List ( RenderType, Shape ) }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { count = 0, shapeList = List.map (Shape.mapPair <| Shape.scale 0.5) initialShapeList }
    , Cmd.none
    )


subscriptions model =
    Time.every 100 Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick t ->
            ( { model
                | count = model.count + 1
                , shapeList = List.map (Shape.mapPair <| Shape.scale (f model.count)) model.shapeList
              }
            , Cmd.none
            )


f : Int -> Float
f count_ =
    let
        t =
            (toFloat count_) / 20.0

        w =
            0.03 * (sin t)
    in
        e ^ w


initialShapeList : List ( RenderType, Shape )
initialShapeList =
    let
        b =
            Shape.basic
    in
        [ ( R, { b | kind = Square, x = 300, y = 300, r = 600, s = 0, l = 0.2 } )
        , ( R, { b | y = 300, x = 60 } )
        , ( R, { b | y = 500, x = 180, r = 40, a = 0.5 } )
        , ( R, { b | kind = Circle, x = 500, y = 150, r = 60, h = 0.1 } )
        , ( R, { b | kind = Circle, x = 580, y = 550, r = 60, h = 0.1, a = 0.25 } )
        , ( RG 10 0.5 0.2, { b | kind = Circle, x = 400, y = 300, r = 180 } )
        , ( RG 20 0.3 0.1, { b | kind = Circle, h = 0.5, x = 80, y = 50, r = 270 } )
        , ( RG 10 0.3 0.05, { b | kind = Square, h = 0.7, x = 40, y = 510, r = 340 } )
        ]


view : Model -> Html Msg
view model =
    let
        b =
            Shape.basic
    in
        svg
            [ width (px 600), height (px 600) ]
        <|
            renderList model.shapeList
