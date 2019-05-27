module App.Data.LoginReducer where

import App.Data.Types (State)
import Radox

-- here are our first actions
data Login
  = StartLogin String String
  | Logout
  | LoginSuccess

instance hasLabelLogin :: HasLabel Login "login" 

loginReducer 
  :: Reducer Login State 
loginReducer (StartLogin _ _) s =
  s { loggedIn = false, loggingIn = true }
loginReducer Logout s
  = s { loggedIn = false, loggingIn = false }
loginReducer LoginSuccess s
  = s { loggedIn = true, loggingIn = false }
