module Pages.Home_ exposing (view)

import Html
import View exposing (View)


view : View msg
view =
    { title = "AWS pipeline"
    , body = [ Html.text "Hello, AWS pipeline!" ]
    }
