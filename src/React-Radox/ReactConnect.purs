module Radox.ReactConnect where
  
import Prelude (Unit, bind, pure, ($))
import Effect (Effect)
import React as React
import Radox

type ReactRadoxContext action state
  = { provider :: React.ReactClass { children :: Array React.ReactElement }
    , connect  :: (forall props localState
                . React.ReactThis props localState
               -> ReactRadoxRenderMethod props state localState action
               -> Effect React.ReactElement)
    }

type ReactRadoxRenderMethod props state localState action 
  = (
      { props :: props
      , localState :: localState
      , state :: state
      , dispatch :: (action -> Effect Unit)
      } -> React.ReactElement
    ) 

createRadoxContext
  :: forall action state
   . CombinedReducer action state
  -> state
  -> ReactRadoxContext action state
createRadoxContext reducer initialState =
  let myContext = React.createContext (emptyStore initialState)
  in  { provider : radoxProvider myContext reducer initialState
      , connect  : radoxConnect myContext
      }
      
radoxProvider 
  :: forall action state
   . React.Context (RadoxStore action state)
  -> CombinedReducer action state 
  -> state
  -> React.ReactClass { children :: Array React.ReactElement }
radoxProvider context combinedReducer initialState 
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

radoxConnect 
  :: forall props localState action state
   . React.Context (RadoxStore action state)
  -> React.ReactThis props localState
  -> ReactRadoxRenderMethod props state localState action
  -> Effect React.ReactElement
radoxConnect context this renderer = do
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
