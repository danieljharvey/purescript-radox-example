module App.Data.LoginReducer where

import Prelude (($))
import App.Data.Actions (login)
import App.Data.Types (State)
import App.Data.ActionTypes (LiftedAction, Login(..))
import Radox

loginReducer 
  :: EffectfulReducer Login State LiftedAction
loginReducer { dispatch } action state
  = case action of
       StartLogin username password -> do
          let newAction = login dispatch username password
          let newState = state { loggedIn = false, loggingIn = true }
          UpdateStateAndRunEffect newState newAction

       Logout ->
          UpdateState $ state { loggedIn = false, loggingIn = false }
       LoginSuccess ->
          UpdateState $ state { loggedIn = true, loggingIn = false }
