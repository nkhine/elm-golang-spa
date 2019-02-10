module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.ListGroup as Listgroup
import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Bootstrap.Utilities.Spacing as Spacing
import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation
import Globals
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Route
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser, s, top)
import Utils exposing (externalLink)


type alias Flags =
    {}


type alias Model =
    { navKey : Navigation.Key
    , page : Page
    , navState : Navbar.State
    , modalVisibility : Modal.Visibility
    }


type Page
    = Home
    | GettingStarted
    | Modules
    | NotFound


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = UrlChange
        }


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate url { navKey = key, navState = navState, page = Home, modalVisibility = Modal.hidden }
    in
    ( model, Cmd.batch [ urlCmd, navCmd ] )


type Msg
    = UrlChange Url
    | ClickedLink UrlRequest
    | NavMsg Navbar.State
    | CloseModal
    | ShowModal


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink req ->
            case req of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.navKey <| Url.toString url )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChange url ->
            urlUpdate url model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

        CloseModal ->
            ( { model | modalVisibility = Modal.hidden }
            , Cmd.none
            )

        ShowModal ->
            ( { model | modalVisibility = Modal.shown }
            , Cmd.none
            )


urlUpdate : Url -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    case decode url of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            ( { model | page = route }, Cmd.none )


decode : Url -> Maybe Page
decode url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> UrlParser.parse routeParser


routeParser : Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map GettingStarted (s "getting-started")
        , UrlParser.map Modules (s "modules")
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Bootstrap"
    , body =
        [ div []
            [ menu model
            , mainContent model
            , modal model
            , viewFooter
            ]
        ]
    }



-- view model =
--     { title = "Elm Bootstrap"
--     , body =
--         [ menu model ]
--             ++ viewPage model
--             ++ [ viewFooter ]
--     }


menu : Model -> Html Msg
menu model =
    Grid.container []
        -- Wrap in a container to center the navbar
        [ Navbar.config NavMsg
            |> Navbar.container
            |> Navbar.collapseSmall
            |> Navbar.withAnimation
            |> Navbar.lightCustomClass "bd-navbar"
            -- Collapse menu at the medium breakpoint
            -- |> Navbar.info
            -- Customize coloring
            |> Navbar.brand
                -- Add logo to your brand with a little styling to align nicely
                [ href "#" ]
                [ img
                    [ src "assets/images/logo.svg"
                    , class "d-inline-block align-top"
                    , style "height" "30px"
                    , style "width" "30px"
                    , alt "Zeitgeist Movement Global Connect"
                    ]
                    []
                ]
            |> Navbar.items
                [ Navbar.itemLink
                    [ href "#" ]
                    [ text "Item 1" ]
                , Navbar.dropdown
                    -- Adding dropdowns is pretty simple
                    { id = "mydropdown"
                    , toggle = Navbar.dropdownToggle [] [ text "My dropdown" ]
                    , items =
                        [ Navbar.dropdownHeader [ text "Heading" ]
                        , Navbar.dropdownItem
                            [ href "#" ]
                            [ text "Drop item 1" ]
                        , Navbar.dropdownItem
                            [ href "#" ]
                            [ text "Drop item 2" ]
                        , Navbar.dropdownDivider
                        , Navbar.dropdownItem
                            [ href "#" ]
                            [ text "Drop item 3" ]
                        ]
                    }
                ]
            |> Navbar.customItems
                [ Navbar.formItem []
                    [ Input.text [ Input.attrs [ placeholder "enter" ] ]
                    , Button.button
                        [ Button.success
                        , Button.attrs [ Spacing.ml2Sm ]
                        ]
                        [ text "Search" ]
                    ]

                -- , Navbar.textItem [ Spacing.ml2Sm, class "muted" ] [ text "Text" ]
                ]
            |> Navbar.view model.navState
        ]



-- viewPage : Model -> List (Html Msg)
-- viewPage model =
--     let
--         wrap =
--             wrapPageLayout model
--     in
--     case model.route of
--         Route.Home ->
--             PHome.view


mainContent : Model -> Html Msg
mainContent model =
    Grid.container [] <|
        case model.page of
            Home ->
                pageHome model

            GettingStarted ->
                pageGettingStarted model

            Modules ->
                pageModules model

            NotFound ->
                pageNotFound


pageHome : Model -> List (Html Msg)
pageHome model =
    [ main_
        [ class "bd-masthead", id "content" ]
        [ div
            [ style "margin" "0 auto 2rem" ]
            [ img
                [ src "assets/images/logo.svg"
                , alt "elm-bootstrap"
                , style "border" "1px solid white"
                , style "width" "120px"
                , style "border-radius" "15%"
                ]
                []
            ]
        , p [ class "lead" ]
            [ text "Build responsive "
            , a
                [ style "color" "#ffe484"
                , href "http://elm-lang.org"
                , target "_blank"
                ]
                [ text "Elm" ]
            , text " applications using "
            , a
                [ href Globals.bootstrapUrl
                , target "_blank"
                , style "color" "#ffe484"
                ]
                [ text "Bootstrap 4" ]
            , text "."
            ]
        , p [ class "version" ]
            [ text "v5.0.0" ]
        ]
    , div
        [ class "bd-featurette" ]
        [ div
            [ class "container" ]
            [ h2
                [ class "bd-featurette-title" ]
                [ text "Responsive and reliable" ]
            , p
                [ class "lead" ]
                [ text """Elm Bootstrap lets you easily create responsive web applications with confidence""" ]
            , div
                [ class "row" ]
                [ div
                    [ class "col-sm-6 mb-3" ]
                    [ h4 [] [ text "Getting started" ]
                    , p []
                        [ text """The easiest way to get started is using the Bootstrap.CDN module, which allows you to inline the latest Bootstrap CSS.
                               This allows you to start using Elm Bootstrap with the elm-reactor from the get go.
                               """
                        , a (Route.clickTo Route.GettingStarted)
                            [ text "Read more..." ]
                        ]
                    ]
                , div
                    [ class "col-sm-6 mb-3" ]
                    [ h4 [] [ text "Reasonably type safe" ]
                    , p []
                        [ text """The Elm Bootstrap library provides a fairly type safe API so that you can spend the majority of your time
                               designing your application not worrying about doing stuff that doesn't make sense or won't work.
                               You'll get sensible defaults and the Elm compiler will have your back most of the time !
                               """
                        ]
                    ]
                ]
            ]
        ]
    ]


pageGettingStarted : Model -> List (Html Msg)
pageGettingStarted model =
    [ h2 [] [ text "Getting started" ]
    , Button.button
        [ Button.success
        , Button.large
        , Button.block
        , Button.attrs [ onClick ShowModal ]
        ]
        [ text "Click me" ]
    ]


pageModules : Model -> List (Html Msg)
pageModules model =
    [ h1 [] [ text "Modules" ]
    , Listgroup.ul
        [ Listgroup.li [] [ text "Alert" ]
        , Listgroup.li [] [ text "Badge" ]
        , Listgroup.li [] [ text "Card" ]
        ]
    ]


pageNotFound : List (Html Msg)
pageNotFound =
    [ h1 [] [ text "Not found" ]
    , text "Sorry couldn't find that page"
    ]


modal : Model -> Html Msg
modal model =
    Modal.config CloseModal
        |> Modal.small
        |> Modal.h4 [] [ text "Getting started ?" ]
        |> Modal.body []
            [ Grid.containerFluid []
                [ Grid.row []
                    [ Grid.col
                        [ Col.xs6 ]
                        [ text "Col 1" ]
                    , Grid.col
                        [ Col.xs6 ]
                        [ text "Col 2" ]
                    ]
                ]
            ]
        |> Modal.view model.modalVisibility


viewFooter : Html Msg
viewFooter =
    footer [ class "bd-footer text-muted" ]
        [ div [ class "container" ]
            [ ul [ class "bd-footer-links" ]
                [ li []
                    [ i [ class "fa fa-github", attribute "aria-hidden" "true" ] []
                    , externalLink Globals.githubDocsUrl " Docs"
                    ]
                , li []
                    [ i [ class "fa fa-github", attribute "aria-hidden" "true" ] []
                    , externalLink Globals.githubSourceUrl " Source"
                    ]
                , li []
                    [ externalLink Globals.packageUrl "Package"
                    ]
                , li []
                    [ externalLink Globals.bootstrapUrl "Bootstrap 4" ]
                ]
            , p []
                [ text "Created by Magnus Rundberget "
                , i [ class "fa fa-twitter", attribute "aria-hidden" "true" ] []
                , externalLink "https://twitter.com/mrundberget" "mrundberget"
                , text " with help from contributor heroes !"
                ]
            , p [] [ text "The code is licensed BSD-3 and the documentation is licensed CC BY 3.0." ]
            ]
        ]
