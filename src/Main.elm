module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, div, h1, h2, img, p, text)
import Html.Attributes exposing (..)


---- MODEL ----


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | Increment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Increment, _ ) ->
            ( model, Cmd.none )

        ( NoOp, _ ) ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ id "main" ]
        [ viewLogo
        , viewBanner
        ]


viewLogo =
    div [ class "logo" ]
        [ img [ src "/logo.png" ] [] ]


viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "Zeitgeist Movement Global Connect!" ]
            , p [] [ text "A place to share your knowledge." ]
            ]
        ]

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = \msg model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }
