module App.Data.Types where

-- an example state type
type State
  = { loggedIn  :: Boolean
    , loggingIn :: Boolean
    , value     :: Int
    }

defaultState :: State
defaultState
  = { loggedIn  : false
    , loggingIn : false
    , value     : 0
    }

    