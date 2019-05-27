module App.Data.RootReducer where

import Data.Variant (Variant, match)
import App.Data.Types (State, defaultState)
import App.Data.LoginReducer (Login, loginReducer)
import App.Data.CountingReducer (Counting, countReducer)
import App.Data.DogReducer (Dogs, dogReducer)
import Puredux.Internal.Types
import Puredux.Connect (Puredux, createPuredux)

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
rootReducer dispatch s action' =
  match
    { login:    \action -> loginReducer dispatch action s
    , counting: \action -> countReducer dispatch action s
    , dogs:     \action -> dogReducer dispatch action s
    } action'

reducer :: Puredux LiftedAction State
reducer = createPuredux rootReducer defaultState
