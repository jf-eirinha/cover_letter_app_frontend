import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes

type Msg
    = DoNothing

type alias Model =
    { model : Int }

type alias Flags =
    ()

init : Flags -> ( Model, Cmd Msg )
init _ =
    ( Model 1 , Cmd.none )

view : Model -> Browser.Document Msg
view model =
    { title = "Uncover"
    , body = [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
                , viewLayout model ]
    }

viewLayout : Model -> Html Msg
viewLayout model =
    div [] [ text ( "Hello, world!" ) ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

main = Browser.document
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }