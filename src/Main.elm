import Browser
import Html exposing (Html)
import Html.Attributes
import Element exposing (Element, rgb, newTabLink, alignBottom, el, paragraph, alignTop, pointer, html, none, htmlAttribute, text, image, row, column, minimum, mouseOver, paddingEach, paddingXY, shrink, alignRight, alignLeft, fill, fillPortion, width, height, rgba255, rgba, rgb255, spacing, centerX, centerY, padding)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Element.Lazy
import Element.Border as Border
import Element.Events as Events
import Http


type Msg
    = GetLetter
    | UpdateLetterText String
    | GotLetter (Result Http.Error String)

type Letter
    = Loading
    | Failure
    | Success String

type alias Model =
    { letterText : String
    , letter : Letter
    }

type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    (
        { letterText = "" 
        , letter = Failure
        }
        , Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Cover Letter Generator"
    , body = [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
                , viewLayout model ]
    }

viewLayout : Model -> Html Msg
viewLayout model =
        Element.layout
            [ width fill 
            , height fill
            ]
            (viewMainRow model)

viewMainRow : Model -> Element Msg
viewMainRow model =
    row
    [ width fill
    , height fill
    , paddingXY 90 80 ]
    [ viewContent model
    , viewLetter model
    ]

viewContent : Model -> Element Msg
viewContent model =
    column
    [ height fill
    , width <| fillPortion 1
    ]
    [ el
        [ width <| Element.px 420
        , height <| Element.px 45
        , Font.family 
                [ Font.typeface "Merriweather"
                , Font.serif ]
        , Font.size 36
        ]
        (text "Cover Letter Generator")
    , el
        [ width <| Element.px 530
        , height <| Element.px 80
        ]
        (paragraph
            [ Font.family 
                [ Font.typeface "Merriweather"
                , Font.serif ]
            , Font.size 14
            ]
            [text ("Tired of writing cover letters? Use the Cover Letter Generator to get a personalized letter for your job application. Get hired! A study made by me shows that 1% of the time it works everytime.")])
    , viewForm model
    , el
        [ alignBottom
        , width <| Element.px 530
        , paddingXY 0 10
        , Border.widthEach
            { bottom = 0
            , left = 0
            , right = 0
            , top = 1
            }
        , Border.color ( rgba255 0 0 0 0.25 )
        ]
        viewCredits
    ]

viewCredits : Element Msg
viewCredits =
    column
    [ Font.family 
        [ Font.typeface "Roboto"
        , Font.sansSerif ]
    , Font.size 12 
    , spacing 10
    ]
    [ paragraph
        []
        [ text "The model is just the medium version (355M parameters) of GPT-2 fine tuned with over 2,000 cover letters scraped from the internet. This could only be built because of various open source contributions, namely from:" ]
    , el
        []
        ( paragraph
        []
        [ text "Max Wolf - "
        , el
            [ Font.semiBold
            , Font.underline
            ]
            ( text "gpt-2-simple" )
        , text " Python package to easily retrain OpenAI's GPT-2 text-generating model on new texts."
        , newTabLink
            [ Font.color ( rgb255 26 13 171 )
            ]
            { url = "https://github.com/minimaxir/gpt-2-simple"
            , label = text " github.com/minimaxir/gpt-2-simple"
            }
        ]
        )
    , paragraph
        []
        [ text "Researchers at OpenAI - "
        , el
            [ Font.semiBold
            , Font.underline
            ]
            ( text "Language Models are Unsupervised Multitask Learners" )
        , text " Radford, Alec and Wu, Jeff and Child, Rewon and Luan, David and Amodei, Dario and Sutskever, Ilya 2019"
        , newTabLink
            [ Font.color ( rgb255 26 13 171 )
            ]
            { url = " https://github.com/openai/gpt-2"
            , label = text " github.com/openai/gpt-2"
            }
        ]
    ]

viewForm : Model -> Element Msg
viewForm model =
    column
    [ width <| Element.px 530
    , height <| Element.px 165
    , spacing 15
    ]
    [ row
        [ height <| Element.px 90
        , spacing 15
        ]
        [ Input.text
            [ height <| Element.px 90
            , width <| Element.px 290
            , Background.color ( rgba255 196 196 196 0.25 )
            , Font.color ( rgba255 0 0 0 0.5 )
            , Font.size 12
            ]
            { onChange = inputOnChange
            , text = model.letterText
            , placeholder = Just <|
                        Input.placeholder
                        []
                        (text "Write the first words of the cover letter")
            , label = Input.labelHidden "Write the first words of the cover letter"
            }
        , el
            [ alignTop ]
            ( text "Example" )
        ]
    , viewButton model
    ]

inputOnChange : String -> Msg
inputOnChange letterText =
    UpdateLetterText letterText

viewButton : Model -> Element Msg
viewButton model =
    Input.button
        [ width <| Element.px 150
        , height <| Element.px 35
        , Background.color ( rgb255 21 26 146 )
        , Font.family 
                [ Font.typeface "Roboto"
                , Font.sansSerif ]
        , Font.size 14
        , Font.color ( rgb255 255 255 255 )
        , Border.rounded 5
        ]
        { onPress = Just GetLetter
        , label = el [ centerX ] ( text "Write a Cover Letter >" )
        }

fetchLetter : Cmd Msg
fetchLetter =
    Http.post
        { url = ""
        , body = Http.emptyBody
        , expect = Http.expectString GotLetter
        }

viewLetter : Model -> Element Msg
viewLetter model =
    case model.letter of

        Failure ->
            el
            [ height fill
            , width <| fillPortion 1 ]
            (text "")

        Loading ->
            el
            [ height fill
            , width <| fillPortion 1 ]
            (text "Loading. A human... I'm sorry, a very sophisticated AI, is now writing your letter. This will take a few minutes.")

        Success newLetter ->
            el
            [ height fill
            , width <| fillPortion 1 ]
            (text newLetter)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        UpdateLetterText newLetterText ->
            ( { model | letterText = newLetterText }, Cmd.none)

        GetLetter ->
            ( model , fetchLetter )

        GotLetter result ->
            case result of
                Ok newLetter ->
                    ( { model | letter = Success newLetter }, Cmd.none)

                Err _ ->
                    ( { model | letter = Failure }, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main = Browser.document
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
