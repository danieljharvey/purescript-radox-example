module App.Data.RootReducer where

import Data.Variant (Variant, match)
import App.Data.Types (State, defaultState)
import App.Data.LoginReducer (Login, loginReducer)
import App.Data.CountingReducer (Counting, countReducer)
import App.Data.DogReducer (Dogs, dogReducer)
import Radox
import Radox.React

type LiftedAction 
  = Variant ( login :: Login
            , counting :: Counting
            , dogs :: Dogs
            )

-- This runs an action through whichever reducer makes sense
-- @match@ uses exhaustiveness checking so we must check for every type
-- this means we can only have one reducer per action type
rootReducer 
  :: CombinedReducer LiftedAction State
rootReducer s action' =
  match
    { login:    \action -> loginReducer action s
    , counting: \action -> countReducer action s
    , dogs:     \action -> dogReducer action s
    } action'

reducer :: ReactRadoxContext LiftedAction State
reducer = createRadoxContext rootReducer defaultState
