module App.Components.Homepage where

import Prelude (Unit, otherwise, pure, show, ($), (==))
import Effect (Effect)
import React.DOM.Props as Props
import React as React
import React.DOM as RDom

import App.Data.RootReducer (LiftedAction, reducer)
import App.Data.Types (State)
import App.Data.CountingReducer (Counting(..))
import App.Data.LoginReducer (Login(..))
import Puredux (liftAction')
import Puredux.Connect

type HomepageProps
  = { title :: String }

homepage :: React.ReactClass HomepageProps
homepage = React.component "homepage" component
  where
    component this = do
          pure $ { state: { }
                 , render: reducer.connect this render 
                 }

render :: PureduxRenderMethod HomepageProps State {} LiftedAction
render all@{ dispatch, state, props } =
  RDom.div [] [ iterator dispatch state
              , login dispatch state
              ]

iterator :: (LiftedAction -> Effect Unit) -> State -> React.ReactElement
iterator dispatch state 
  = RDom.p [ Props.onClick (\_ -> dispatch (liftAction' Up)) ] 
    [ RDom.text (show state.value) ] 

login :: (LiftedAction -> Effect Unit) -> State -> React.ReactElement
login dispatch state 
  = RDom.div [ ] [ button, label ]
  where
    button 
      = RDom.button 
          [ Props.onClick (\_ 
              -> do
                if state.loggedIn == false
                  then
                    dispatch (liftAction' $ StartLogin "Hello" "World")
                  else
                    dispatch (liftAction' Logout)) 
          ] 
          [ RDom.text (if state.loggedIn then "Logout" else "Login" )] 
    label 
      = RDom.p [] [ RDom.text (buttonText state) ]

buttonText :: State -> String
buttonText state
  | state.loggedIn == true = "Logged in!"
  | state.loggingIn == true = "Logging in..."
  | otherwise = "Not logged in"