# Journal

## Day 1, January 15, 2019

**11:00 am.** Submitted a bodacious proposal for a talk on interacting with dynamic generative art, not having done any work at all on the project.

**9:30 - 11:30 pm.** Made a start on the project.  Decided to use the `elm-community/typed-svg` library. The first step is to write a small module of functions to draw shapes.  The shapes must be easy to manipulate numerically: easy to translate, change the size, change the color.  So here are the type definitions:

```
type Kind
    = Circle
    | Square


type alias Shape =
    { kind : Kind
    , cx : Float
    , cy : Float
    , r : Float
    , angle : Float
    , h : Float
    , s : Float
    , l : Float
    , a : Float
    }
```

Next, I wrote a rendering function:

```
render : Shape -> Svg msg
render shape =
    case shape.kind of
        Circle ->
            renderCircle shape

        Square ->
            renderSquare shape
```
This can easily be extended to more shapes.

There is a default shape, `Shape.basic` which can be used as a starting point:

```
basic =
    { kind = Circle
    , cx = 10
    , cy = 10
    , r = 10
    , angle = 0
    , h = 1.0
    , s = 0.5
    , l = 0.5
    , a = 1.0
    }
```
This is how I made the first drawing:

```
view : Model -> Html Msg
view model =
    let
        b = Shape.basic
    in
        svg [ viewBox 0 0 300 300 ]
          <|
            [ render { b | kind = Square, cx = 40, cy = 40, r = 80, s = 0, l = 0.2 }
            , render b
            , render { b | kind = Square, cx = 40, h = 0.3 }
            ]
```

Very boring, so let's make something more interesting:

![Image](image/day1.png)

The new element is the function below.  It permits one to make "graded" shapes.

```
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
```
