module App.Data.CountingReducer where

import Prelude ((+), (-))

import App.Data.ActionTypes (Counting(..))
import App.Data.Types (State)
import Radox

-- ahoy, welcome to the world's shittest reducer
countReducer 
  :: Reducer Counting State 
countReducer Up s
  = s { value = s.value + 1 }
countReducer Down s
  = s { value = s.value - 1 }
