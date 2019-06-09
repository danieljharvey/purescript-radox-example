module App.Data.Types where


-- an example state type
type State
  = { loggedIn  :: Boolean
    , loggingIn :: Boolean
    , value     :: Int
    , dog       :: DogState
    }

data DogState
  = NotTried
  | LookingForADog
  | FoundADog String
  | CouldNotFindADog

defaultState :: State
defaultState
  = { loggedIn  : false
    , loggingIn : false
    , value     : 0
    , dog       : NotTried
    }

--- Dog CEO return type

type DogResponse
  = { status  :: String
    , message :: String
    }


