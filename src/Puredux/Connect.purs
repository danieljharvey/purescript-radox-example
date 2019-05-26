module Puredux.Connect where
  
import Prelude (Unit, bind, pure, ($))
import Effect (Effect)
import React as React
import Puredux (createStore, emptyStore)
import Puredux.Internal.Types

-- This section is full of components to use Puredux with Purescript React

type Puredux action state
  = { provider :: React.ReactClass { children :: Array React.ReactElement }
    , connect  :: (forall props localState
                . React.ReactThis props localState
               -> PureduxRenderMethod props state localState action
               -> Effect React.ReactElement)
    }

type PureduxRenderMethod props state localState action 
  = (
      { props :: props
      , localState :: localState
      , state :: state
      , dispatch :: (action -> Effect Unit)
      } -> React.ReactElement
    ) 

createPuredux 
  :: forall action state
   . CombinedReducer action state
  -> state
  -> Puredux action state
createPuredux reducer initialState =
  let myContext = React.createContext (emptyStore initialState)
  in  { provider : pureduxProvider myContext reducer initialState
      , connect  : pureduxConnect myContext
      }
      
pureduxProvider 
  :: forall action state
   . React.Context (Store' action state)
  -> CombinedReducer action state 
  -> state
  -> React.ReactClass { children :: Array React.ReactElement }
pureduxProvider context combinedReducer initialState 
  = React.pureComponent "Provider" component
  where
    listener 
      :: React.ReactThis 
          { children     :: Array React.ReactElement } 
          { pureduxState :: state } 
      -> state 
      -> Effect Unit
    listener this' newState
        = React.modifyState this' (\_ -> { pureduxState: newState })

    component this = do
        store  <- createStore initialState [ (listener this) ] combinedReducer
        pure $ { state  : { pureduxState: initialState }
               , render : render' this store
               }

    render' this store = do
        props <- React.getProps this
        state <- React.getState this
        pure $ 
            React.createElement 
              context.provider 
              { value: { state: state.pureduxState
                       , dispatch: store.dispatch 
                       } 
              }
              props.children

pureduxConnect 
  :: forall props localState action state
   . React.Context (Store' action state)
  -> React.ReactThis props localState
  -> PureduxRenderMethod props state localState action
  -> Effect React.ReactElement
pureduxConnect context this renderer = do
  props <- React.getProps this
  localState <- React.getState this
  let render { state, dispatch } 
        = renderer { props: props
                   , state: state
                   , localState: localState
                   , dispatch: dispatch
                   } 
  pure $ React.createLeafElement context.consumer
          { children: render }
