module App.Data.CountingReducer where

import Prelude (pure, ($), (+), (-))
import Data.Variant (Variant)

import App.Data.Types (State)
import Puredux.Internal.Types

-- here are our second actions
data Counting
  = Up
  | Down

instance hasLabelCounting :: HasLabel Counting "counting"

type CountingAction r
  = Variant (counting :: Counting | r)

countReducer 
  :: forall r. Reducer (CountingAction r) Counting State 
countReducer _ Up s
  = pure $ s { value = s.value + 1 }
countReducer _ Down s
  = pure $ s { value = s.value - 1 }
