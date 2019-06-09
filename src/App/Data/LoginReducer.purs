module App.Data.LoginReducer where

import Prelude (discard, pure, ($))
import App.Data.Actions (login)
import App.Data.Types (State)
import App.Data.ActionTypes (LiftedAction, Login(..))
import Radox

loginReducer 
  :: EffectfulReducer Login State LiftedAction
loginReducer { dispatch } action state
  = case action of
       StartLogin username password -> do
          login dispatch username password
          pure $ state { loggedIn = false, loggingIn = true }
       Logout ->
          pure $ state { loggedIn = false, loggingIn = false }
       LoginSuccess ->
          pure $ state { loggedIn = true, loggingIn = false }
