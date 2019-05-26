module Puredux.Internal.Types where

import Prelude
import Effect (Effect)

type Reducer allActionType actionType stateType
  =  (allActionType -> Effect Unit)
  -> actionType
  -> stateType
  -> Effect stateType

type CombinedReducer actionType stateType
  =  (actionType -> Effect Unit)
  -> stateType
  -> actionType
  -> Effect stateType

type Listeners stateType
  = Array (stateType -> Effect Unit)

type Dispatcher actionType
  = actionType -> Effect Unit

type Store actionType stateType
  = { dispatch :: Dispatcher actionType
    , getState :: Effect stateType
    }

type Store' actionType stateType
  = { dispatch :: Dispatcher actionType
    , state :: stateType
  }

class HasLabel a (p :: Symbol) | a -> p 