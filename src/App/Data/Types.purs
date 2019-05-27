module App.Data.Types where

import Data.Argonaut (class DecodeJson)
import Data.Generic.Rep
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)

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

newtype DogResponse
  = DogResponse 
      { status  :: String
      , message :: String
      }

derive instance genericDogResponse :: Generic DogResponse _

instance decodeJsonDogResponse :: DecodeJson DogResponse where
  decodeJson = genericDecodeJson 
