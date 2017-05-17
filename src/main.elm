module Main exposing (..)

-- Thinking about how to do persistence
-- Probably Localstorage plus Dropbox
-- if characters get separate records in Localstorage,
-- they should have a prefix like char5e- and the character name
-- and a version field as one of the values
-- Either the whole JSON or any fields that fail to map for loading
-- should concatenate and dump to a catchall field from which data can be retrieved
-- manually as the data model evolves. That way a player can see the
-- data that needs to be put into the new format.

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL
-- could add ideals and flaws explicitly instead of lumping to goals and personality
-- might eventually break out some of the repeaters like weapons blocks and spell lists

type alias CharacterClass =
    { classname : String, classlevel : Int }


type alias Spell =
    { level : Int, name : String, prepared : Bool }


type alias Save =
    { proficient : Bool, bonus : Int, bonusSources : String, add : Int }


type alias PrimeAttribute =
    Int

type alias Level =
    Int

type alias SavingThrow =
    Int


type alias Model =
    { dieFace : Int
    , dieType : Int
    , strength : PrimeAttribute
    , intelligence : PrimeAttribute
    , dexterity : PrimeAttribute
    , wisdom : PrimeAttribute
    , charisma : PrimeAttribute
    , constitution : PrimeAttribute
    , name : String
    , race : String
    , class : String
    , classLevel : Level
    , class2 : String
    , class2Level : Level
    , class3 : String
    , class3Level : Int
    , characterlevel : Level
    , personality : String
    , description : String
    , goals : String
    , backstory : String
    , cash : String
    , mundaneitems : String
    , magicitems : String
    , armorclass : String
    , spellsknown : String
    , spellsprepared : String
    , spellslots : String
    , initiative : Level
    , movedistance : String
    , skills : String
    , strSave : SavingThrow
    , intSave : SavingThrow
    , wisSave : SavingThrow
    , conSave : SavingThrow
    , dexSave : SavingThrow
    , chaSave : SavingThrow
    , strSaveProf : Bool
    , intSaveProf : Bool
    , wisSaveProf : Bool
    , conSaveProf : Bool
    , dexSaveProf : Bool
    , chaSaveProf : Bool
    , spells : List Spell
    , spellDc : Int
    , currenthitpoints : String
    , maxhitpoints : Int
    , bonushitpoints : String
    , statuseffects : String
    , friends : String
    , classfeatures : String
    , racefeatures : String
    , encounters : String
    , campaignnotes : String
    , languages : String
    , toolproficiencies : String
    , weapons : String
    }


init : ( Model, Cmd Msg )
init =
    ( { dieFace = 1
      , dieType = 6
      , strength = 0
      , intelligence = 0
      , dexterity = 0
      , wisdom = 0
      , charisma = 0
      , constitution = 0
      , name = "Name me"
      , race = "Choose race"
      , class = "Choose class"
      , classLevel = 1
      , class2 = ""
      , class2Level = 0
      , class3 = ""
      , class3Level = 0
      , characterlevel = 1
      , personality = "Describe my personality, ideals, flaws"
      , description = "Physical description"
      , goals = "Describe my goals"
      , backstory = "Describe my backstory"
      , cash = "list my cash treasure"
      , mundaneitems = "my mundane items"
      , magicitems = "my magic items"
      , armorclass = "armor class is free text so you can list shielded, shieldless, and other variations"
      , initiative = 0
      , movedistance = "30"
      , skills = "List my skills, freeform for now"
      , strSave = 0
      , intSave = 0
      , wisSave = 0
      , conSave = 0
      , dexSave = 0
      , chaSave = 0
      , strSaveProf = False
      , intSaveProf = False
      , wisSaveProf = False
      , conSaveProf = False
      , dexSaveProf = False
      , chaSaveProf = False
      , spells = []
      , spellslots = "List spell slots"
      , spellsprepared = "List spells prepared"
      , spellsknown = "List spells known"
      , spellDc = 10
      , currenthitpoints = "Track my current hitpoints"
      , maxhitpoints = 1
      , bonushitpoints = "Track temporary bonus hitpoints"
      , statuseffects = "statuses, death saves, etc"
      , friends = "My friends"
      , classfeatures = "List my class features"
      , racefeatures = "List my racial features"
      , encounters = "List encounter notes"
      , campaignnotes = "List campaign notes"
      , languages = "Common"
      , toolproficiencies = "List tool proficiencies"
      , weapons = "Freeform weapons blocks for now"
      }
    , Cmd.none
    )


attributeModifier modelAttribute =
    modelAttribute//2 - 5


attributeModifierString modelAttribute =
    toString (attributeModifier modelAttribute)



-- UPDATE


type Msg
    = Roll
    | NewFace Int
    | NewType String
    | NewStrength String
    | NewIntelligence String
    | NewWisdom String
    | NewDexterity String
    | NewConstitution String
    | NewCharisma String
    | NewName String
    | NewClass String
    | NewClassLevel String
    | NewClass2 String
    | NewClass2Level String
    | NewClass3 String
    | NewClass3Level String
    | NewClassfeatures String
    | NewRacefeatures String
    | NewMaxhitpoints String
    | NewCurrenthitpoints String
    | NewBonushitpoints String
    | NewSpellDc String
    | NewFriends String
    | NewMundaneitems String
    | NewMagicitems String
    | NewEncounters String
    | NewCampaignnotes String
    | NewCharacterlevel String
    | NewBackstory String
    | NewRace String
    | NewPersonality String
    | NewGoals String
    | NewCash String
    | NewDescription String
    | NewInitiative String
    | NewStatuseffects String
    | NewMovedistance String
    | NewLanguages String
    | NewToolproficiencies String
    | NewArmorclass String
    | NewSpellsknown String
    | NewSpellsprepared String
    | NewSpellslots String
    | NewSkills String
    | NewWeapons String
    | NewStrSave String
    | NewDexSave String
    | NewConSave String
    | NewIntSave String
    | NewWisSave String
    | NewChaSave String
    | ToggleStrSaveProf
    | ToggleConSaveProf
    | ToggleIntSaveProf
    | ToggleWisSaveProf
    | ToggleDexSaveProf
    | ToggleChaSaveProf





update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 model.dieType) )

        NewFace new ->
            ( { model | dieFace = new }, Cmd.none )

        NewType new ->
            ( { model | dieType = Result.withDefault 6 (String.toInt new) }, Cmd.none )

        NewStrength new ->
            ( { model | strength = Result.withDefault 0 (String.toInt new) }, Cmd.none )

        NewIntelligence new ->
            ( { model | intelligence = Result.withDefault 0 (String.toInt new) }, Cmd.none )

        NewWisdom new ->
            ( { model | wisdom = Result.withDefault 0 (String.toInt new) }, Cmd.none )

        NewConstitution new ->
            ( { model | constitution = Result.withDefault 0 (String.toInt new) }, Cmd.none )

        NewCharisma new ->
            ( { model | charisma = Result.withDefault 0 (String.toInt new) }, Cmd.none )

        NewDexterity new ->
            ( { model | dexterity = Result.withDefault 0 (String.toInt new) }, Cmd.none )

        NewName new ->
            ( { model | name = new }, Cmd.none )

        NewClassfeatures new ->
            ( { model | classfeatures = new }, Cmd.none )

        NewClass new ->
            ( { model | class = new }, Cmd.none )

        NewClassLevel new ->
            ( { model | classLevel = Result.withDefault 6 (String.toInt new ) }, Cmd.none )

        NewClass2 new ->
            ( { model | class = new }, Cmd.none )

        NewClass2Level new ->
            ( { model | class2Level = Result.withDefault 6 (String.toInt new) }, Cmd.none )

        NewClass3 new ->
            ( { model | class = new }, Cmd.none )

        NewClass3Level new ->
            ( { model | class3Level = Result.withDefault 6 (String.toInt new) }, Cmd.none )

        NewRacefeatures new ->
            ( { model | racefeatures = new }, Cmd.none )

        NewFriends new ->
            ( { model | friends = new }, Cmd.none )

        NewMundaneitems new ->
            ( { model | friends = new }, Cmd.none )

        NewMagicitems new ->
            ( { model | friends = new }, Cmd.none )

        NewRace new ->
            ( { model | race = new }, Cmd.none )

        NewCharacterlevel new ->
            ( { model | characterlevel = Result.withDefault 1 (String.toInt new) }, Cmd.none )

        NewPersonality new ->
            ( { model | personality = new }, Cmd.none )

        NewBackstory new ->
            ( { model | backstory = new }, Cmd.none )

        NewCash new ->
            ( { model | cash = new }, Cmd.none )

        NewGoals new ->
            ( { model | goals = new }, Cmd.none )

        NewDescription new ->
            ( { model | description = new }, Cmd.none )

        NewEncounters new ->
            ( { model | encounters = new }, Cmd.none )

        NewCampaignnotes new ->
            ( { model | campaignnotes = new }, Cmd.none )

        NewSpellDc new ->
            ( { model | spellDc = Result.withDefault 1 (String.toInt new) }, Cmd.none )

        NewInitiative new ->
            ( { model | initiative = Result.withDefault 1 (String.toInt new) }, Cmd.none )

        NewMaxhitpoints new ->
            ( { model | maxhitpoints = Result.withDefault 1 (String.toInt new) }, Cmd.none )

        NewCurrenthitpoints new ->
            ( { model | currenthitpoints = new }, Cmd.none )

        NewBonushitpoints new ->
            ( { model | bonushitpoints = new }, Cmd.none )

        NewStatuseffects new ->
            ( { model | statuseffects = new }, Cmd.none )

        NewMovedistance new ->
            ( { model | movedistance = new }, Cmd.none )

        NewLanguages new ->
            ( { model | languages = new }, Cmd.none )

        NewToolproficiencies new ->
            ( { model | toolproficiencies = new }, Cmd.none )

        NewArmorclass new ->
            ( { model | armorclass = new }, Cmd.none )

        NewSpellsknown new ->
            ( { model | armorclass = new }, Cmd.none )

        NewSpellsprepared new ->
            ( { model | armorclass = new }, Cmd.none )

        NewSpellslots new ->
            ( { model | armorclass = new }, Cmd.none )

        NewWeapons new ->
            ( { model | weapons = new }, Cmd.none )

        NewSkills new ->
            ( { model | skills = new }, Cmd.none )

        NewStrSave new ->
            ( { model | strSave = Result.withDefault 0 (String.toInt new) }, Cmd.none  )

        NewDexSave new ->
            ( { model | dexSave = Result.withDefault 0 (String.toInt new) }, Cmd.none  )

        NewConSave new ->
            ( { model | conSave = Result.withDefault 0 (String.toInt new) }, Cmd.none  )

        NewIntSave new ->
            ( { model | intSave = Result.withDefault 0 (String.toInt new) }, Cmd.none  )

        NewWisSave new ->
            ( { model | wisSave = Result.withDefault 0 (String.toInt new) }, Cmd.none  )

        NewChaSave new ->
            ( { model | chaSave = Result.withDefault 0 (String.toInt new) }, Cmd.none  )

        ToggleStrSaveProf ->
            ( { model | strSaveProf = not model.strSaveProf }, Cmd.none )

        ToggleIntSaveProf ->
            ( { model | intSaveProf = not model.intSaveProf }, Cmd.none )

        ToggleWisSaveProf ->
            ( { model | wisSaveProf = not model.wisSaveProf }, Cmd.none )

        ToggleConSaveProf ->
            ( { model | conSaveProf = not model.conSaveProf }, Cmd.none )

        ToggleDexSaveProf ->
            ( { model | dexSaveProf = not model.dexSaveProf }, Cmd.none )

        ToggleChaSaveProf ->
            ( { model | chaSaveProf = not model.chaSaveProf }, Cmd.none )



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div [ id "dieroll", style [ ( "display", "none" ) ] ]
            [ h1 [] [ text (toString model.dieFace) ]
            , button [ onClick Roll ] [ text "Roll" ]
            , br [] []
            , br [] []
            , span [] [ text "Die Type " ]
            , input [ onInput NewType ] []
            ]
        , div [ id "charactersheet" ]
            [ h1 [] [ text "Character Sheet 5e" ]
            , p []
                [ label [] [ text ("Name") ]
                , input [ id "name", onInput NewName, value model.name] [ text model.name ]
                ]
            , p []
                [ label [] [ text ("Race") ]
                , input [ id "race", onInput NewRace, value model.race ] []
                ]
            , p []
                [ label [] [ text ("Primary Class") ]
                , input [ id "class", onInput NewClass, value model.class] []
                , label [] [ text ("Level") ]
                , input [ id "classLevel", onInput NewClassLevel, value( toString model.classLevel) ] []
                , br [][]
                , label [] [ text ("2nd Class") ]
                , input [ id "class2", onInput NewClass2, value model.class2] []
                , label [] [ text ("Level") ]
                , input [ id "class2Level", onInput NewClass2Level, value( toString model.class2Level) ] []
                , br [][]
                , label [] [ text ("3rd Class") ]
                , input [ id "class3", onInput NewClass3, value model.class3] []
                , label [] [ text ("Level") ]
                , input [ id "class3Level", onInput NewClass3Level, value( toString model.class3Level) ] []
                ]
            , p []
                [ label [] [ text ("Character Level") ]
                , input [ id "characterlevel"
                          , onInput NewCharacterlevel
                          , value (toString model.characterlevel)
                        ] []
                ]
            , h2 [] [ text "Attributes" ]
            , ul []
                [ li []
                    [ text "Strength: "
                    , input
                        [ id "strength"
                        , onInput NewStrength
                        , value (toString model.strength)
                        ]
                        []
                    , span [ id "strMod" ] [ text (attributeModifierString model.strength) ]
                    ]
                , li []
                    [ text "Dexterity: "
                    , input
                        [ id "dexterity"
                        , onInput NewDexterity
                        , value (toString model.dexterity)
                        ]
                        []
                    , span [ id "dexMod" ] [ text (attributeModifierString model.dexterity) ]
                    ]
                , li []
                    [ text "Constitution: "
                    , input
                        [ id "constitution"
                        , onInput NewConstitution
                        , value (toString model.constitution)
                        ]
                        []
                    , span [ id "conMod" ] [ text (attributeModifierString model.constitution) ]
                    ]
                , li []
                    [ text "Intelligence: "
                    , input
                        [ id "intelligence"
                        , onInput NewIntelligence
                        , value (toString model.intelligence)
                        ]
                        []
                    , span [ id "intMod" ] [ text (attributeModifierString model.intelligence) ]
                    ]
                , li []
                    [ text "Wisdom: "
                    , input
                        [ id "wisdom"
                        , onInput NewWisdom
                        , value (toString model.wisdom)
                        ]
                        [ ]
                    , span [ id "wisMod" ] [ text (attributeModifierString model.wisdom) ]
                    ]
                , li []
                    [ text "Charisma: "
                    , input
                        [ id "charisma"
                        , onInput NewCharisma
                        , value (toString model.charisma)
                        ]
                        []
                    , span [ id "chaMod" ] [ text (attributeModifierString model.charisma) ]
                    ]
                ]
            , h2 [] [ text "Saves" ]
            , ul [] [
                    li [] [ checkbox ToggleStrSaveProf "Strength"
                          , input [ id "strSave", onInput NewStrSave ] []
                          ]

                    , li [] [ checkbox ToggleDexSaveProf "Dexterity"
                            , input [ id "dexSave", onInput NewDexSave ] []
                            ]

                    , li [] [ checkbox ToggleConSaveProf "Constitution"
                            , input [ id "conSave", onInput NewConSave ] []
                            ]

                    , li [] [ checkbox ToggleIntSaveProf "Intelligence"
                            , input [ id "intSave", onInput NewIntSave ] []
                            ]

                    , li [] [ checkbox ToggleWisSaveProf "Wisdom"
                            , input [ id "wisSave", onInput NewWisSave ] []
                            ]

                    , li [] [ checkbox ToggleChaSaveProf "Charisma"
                            , input [ id "chaSave", onInput NewChaSave ] []
                            ]
                      ]
            , h2 [] [ text "Skills" ]
            , textarea [ id "skills", onInput NewSkills ] [ text model.skills ]
            , h2 [] [ text "Combat" ]
            , p []
                [ label [] [ text ("Initiative") ]
                , input [ id "initiative", onInput NewInitiative, value (toString model.initiative) ] []
                ]
            , p []
                [ label [] [ text ("Move Distance") ]
                , input [ id "movedistance", onInput NewMovedistance, value (model.movedistance) ] []
                ]
            , p []
                [ label [] [ text ("Armor class") ]
                , textarea [ id "armorclass", onInput NewArmorclass ] [ text model.armorclass ]
                ]
            , p []
                [ label [] [ text ("Spell DC for reference") ]
                , span [ id "spellDcRef" ] [ text (toString model.spellDc) ]
                ]
            , p []
                [ label [] [ text ("Max Hitpoints") ]
                , input [ id "maxhitpoints", onInput NewMaxhitpoints, value (toString model.maxhitpoints) ] []
                ]
            , p []
                [ label [] [ text ("Current Hitpoints") ]
                , textarea [ id "currenthitpoints", onInput NewCurrenthitpoints ] [ text ( model.currenthitpoints ) ]
                ]
            , p []
                [ label [] [ text ("Bonus Hitpoints") ]
                , textarea [ id "bonushitpoints", onInput NewBonushitpoints ]  [text (model.bonushitpoints) ]
                ]
            , p []
                [ label [] [ text ("Status Effects") ]
                , textarea [ id "statuseffects", onInput NewStatuseffects ] [ text model.statuseffects ]
                ]
            , h3 [] [ text "Weapons blocks" ]
            , textarea [ id "weapons", onInput NewWeapons ] [ text model.weapons ]
            , h2 [] [ text "Magic" ]
            , p []
                [ label [] [ text ("Spell DC") ]
                , input [ id "spellDc", onInput NewSpellDc ] [ text ( toString model.spellDc ) ]
                ]
            , p []
                [ label [] [ text ("Spells Known") ]
                , textarea [ id "spellsknown", onInput NewSpellsknown ] [ text model.spellsknown ]
                ]
            , p []
                [ label [] [ text ("Spells Prepared") ]
                , textarea [ id "spellsprepared", onInput NewSpellsprepared ] [ text model.spellsprepared ]
                ]
            , p []
                [ label [] [ text ("Spell Slots") ]
                  , textarea [ id "spellsknown", onInput NewSpellslots ] [ text model.spellslots ]
                ]
            , h2 [] [ text "Possessions" ]
            , p []
                [ label [] [ text ("Cash treasure") ]
                , textarea [ id "cash", onInput NewCash ] [ text model.cash ]
                ]
            , p []
                [ label [] [ text ("Mundane Items") ]
                , textarea [ id "mundaneitems", onInput NewMundaneitems ] [ text model.mundaneitems ]
                ]
            , p []
                [ label [] [ text ("Magic Items") ]
                , textarea [ id "magicitems", onInput NewMagicitems ] [ text model.magicitems ]
                ]
            , h2 [] [ text "About" ]
            , p []
                [ label [] [ text ("Tool proficiencies") ]
                , textarea [ id "toolproficiencies", onInput NewToolproficiencies ] [ text model.toolproficiencies ]
                ]
            , p []
                [ label [] [ text ("Languages") ]
                , textarea [ id "languages", onInput NewLanguages ] [ text model.languages ]
                ]
            , p []
                [ label [] [ text ("Racial Features") ]
                , textarea [ id "racefeatures", onInput NewRacefeatures ] [ text model.racefeatures ]
                ]
            , p []
                [ label [] [ text ("Class Features") ]
                , textarea [ id "classfeatures", onInput NewClassfeatures ] [ text model.classfeatures ]
                ]
            , p []
                [ label [] [ text ("Physical Description") ]
                , textarea [ id "description", onInput NewDescription ] [ text model.description ]
                ]
            , p []
                [ label [] [ text ("Personality") ]
                , textarea [ id "personality", onInput NewPersonality ] [ text model.personality ]
                ]
            , p []
                [ label [] [ text ("Goals") ]
                , textarea [ id "goals", onInput NewGoals ] [ text model.goals ]
                ]
            , h2 [] [ text "Notes" ]
            , p []
                [ label [] [ text ("Backstory") ]
                , textarea [ id "backstory", onInput NewBackstory ] [ text model.backstory ]
                ]
            , p []
                [ label [] [ text ("Encounters") ]
                , textarea [ id "encounters", onInput NewEncounters ] [ text model.encounters ]
                ]
            , p []
                [ label [] [ text ("Campaign Notes") ]
                , textarea [ id "campaignnotes", onInput NewCampaignnotes ] [ text model.campaignnotes ]
                ]
            ]
        ]

checkbox : msg -> String -> Html msg
checkbox msg name =
  label
    [ style [("padding", "20px")]
    ]
    [ input [ type_ "checkbox", onClick msg ] []
    , text name
    ]
