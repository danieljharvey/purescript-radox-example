module Puredux where

import Prelude (Unit, bind, pure, unit, ($))
import Effect (Effect)
import Effect.Ref (Ref, new, read, write)
import Data.Traversable (traverse)
import Data.Variant (SProxy(..), Variant, inj)
import Data.Symbol (class IsSymbol)
import Prim.Row (class Cons)
import Puredux.Internal.Types

-- This is the machinery for using Puredux standalone

createStore 
  :: forall stateType actionType
   . stateType
  -> Listeners stateType
  -> CombinedReducer actionType stateType
  -> Effect (Store actionType stateType)
createStore state listeners reducers = do
  stateRef <- new state
  pure $ { dispatch: update stateRef listeners reducers
         , getState: (getState stateRef)
         }

emptyStore 
  :: forall stateType actionType 
   . stateType 
   -> Store' actionType stateType
emptyStore initial
  = { dispatch: \_ -> pure unit
    , state: initial
    }

update 
  :: forall stateType actionType
   . Ref stateType
  -> Listeners stateType
  -> CombinedReducer actionType stateType
  -> actionType
  -> Effect Unit
update stateRef listeners reducers action = do
  -- read current state
  oldState <- read stateRef
  -- create a dispatcher for the reducers to use
  let dispatch = update stateRef listeners reducers
  -- calculate new state
  newState <- reducers dispatch oldState action
  -- announce new state to listeners
  _ <- traverse (\f -> f newState) listeners
  -- save new state
  write newState stateRef

-- read state from the mutable Ref and return it
getState
  :: forall stateType 
   . Ref stateType
  -> Effect stateType
getState stateRef = read stateRef

-- take one of our separated Action sumtypes and lift it into Variant-land
liftAction' 
  :: forall label action dunno r. 
  Cons label action dunno r 
  => HasLabel action label 
  => IsSymbol label 
  => action 
  -> Variant r
liftAction'  
  = inj (SProxy :: SProxy label) 
