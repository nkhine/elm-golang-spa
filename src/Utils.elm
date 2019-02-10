module Utils exposing (externalLink)

import Html exposing (..)
import Html.Attributes exposing (href, target)


externalLink : String -> String -> Html msg
externalLink url label =
    a [ href url, target "_blank" ]
        [ text label ]
