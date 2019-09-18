module App.Data.RootReducer where

import Prelude (($))
import Data.Variant (match)
import App.Data.ActionTypes (LiftedAction)
import App.Data.Types (State, defaultState)
import App.Data.LoginReducer (loginReducer)
import App.Data.CountingReducer (countReducer)
import App.Data.DogReducer (dogReducer)
import Radox (CombinedReducer, ReducerReturn(..)) 
import Radox.React

-- This runs an action through whichever reducer makes sense
-- @match@ uses exhaustiveness checking so we must check for every type
-- this means we can only have one reducer per action type
rootReducer 
  :: CombinedReducer LiftedAction State
rootReducer helpers state action' =
  match
    { login:    \action -> 
                  loginReducer helpers action state
    , counting: \action -> 
                  UpdateState $ countReducer action state
    , dogs:     \action -> 
                  dogReducer helpers action state
    } action'

reducer :: ReactRadoxContext LiftedAction State
reducer = createRadoxContext rootReducer defaultState
