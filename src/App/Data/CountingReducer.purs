module App.Data.CountingReducer where

import Prelude ((+), (-))

import App.Data.Types (State)
import Puredux.Internal.Types

-- here are our second actions
data Counting
  = Up
  | Down

instance hasLabelCounting :: HasLabel Counting "counting"

countReducer 
  :: Reducer Counting State 
countReducer Up s
  = s { value = s.value + 1 }
countReducer Down s
  = s { value = s.value - 1 }
