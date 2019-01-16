module Shape
    exposing
        ( Kind(..)
        , Shape
        , RenderType(..)
        , render
        , renderGradientShape
        , renderList
        , basic
        , move
        , scale
        , mapPair
        )

import Color
import TypedSvg exposing (svg)
import TypedSvg.Attributes exposing (cx, cy, x, y, height, width, fill, r, stroke, strokeWidth, viewBox)
import TypedSvg.Types exposing (Fill(..), px)
import Svg exposing (Svg)


type Kind
    = Circle
    | Square


type alias Shape =
    { kind : Kind
    , x : Float
    , y : Float
    , r : Float
    , angle : Float
    , h : Float
    , s : Float
    , l : Float
    , a : Float
    }


type RenderType
    = R
    | RG Int Float Float


basic =
    { kind = Circle
    , x = 10
    , y = 10
    , r = 10
    , angle = 0
    , h = 1.0
    , s = 0.5
    , l = 0.5
    , a = 1.0
    }


render : Shape -> Svg msg
render shape =
    case shape.kind of
        Circle ->
            renderCircle shape

        Square ->
            renderSquare shape


renderCircle : Shape -> Svg msg
renderCircle shape =
    TypedSvg.circle
        [ cx (px shape.x)
        , cy (px shape.y)
        , r (px shape.r)
        , fill <| Fill (Color.hsla shape.h shape.s shape.l shape.a)
        ]
        []


renderGradientShape : Shape -> Int -> Float -> Float -> List (Svg msg)
renderGradientShape shape steps exponent alpha =
    let
        range =
            List.map (\x -> (toFloat x) ^ exponent) (List.range 1 steps)

        shapes =
            List.map
                (\k -> { shape | r = shape.r / k, a = alpha })
                range
    in
        List.map render shapes


renderSquare : Shape -> Svg msg
renderSquare shape =
    TypedSvg.rect
        [ x (px (shape.x - shape.r))
        , y (px (shape.y - shape.r))
        , width (px <| 2 * shape.r)
        , height (px <| 2 * shape.r)
        , fill <| Fill (Color.hsla shape.h shape.s shape.l shape.a)
        ]
        []


renderPair : ( RenderType, Shape ) -> List (Svg msg)
renderPair ( renderType, shape ) =
    case renderType of
        R ->
            [ render shape ]

        RG steps exponent alpha ->
            renderGradientShape shape steps exponent alpha


renderList : List ( RenderType, Shape ) -> List (Svg msg)
renderList pairList =
    pairList
        |> List.map renderPair
        |> List.concat


move : Float -> Float -> Float -> Shape -> Shape
move dx dy dr shape =
    { shape
        | x = shape.x + dx
        , y = shape.y + dy
        , r = shape.r + dr
    }


scale : Float -> Shape -> Shape
scale k shape =
    { shape | r = k * shape.r }


mapPair : (Shape -> Shape) -> ( RenderType, Shape ) -> ( RenderType, Shape )
mapPair f ( renderType, shape ) =
    ( renderType, f shape )