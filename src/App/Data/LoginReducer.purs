module App.Data.LoginReducer where

import Prelude (bind, pure, ($))
import Data.Variant (Variant)
import Effect.Timer as T

import App.Data.Types (State)
import Puredux (liftAction')
import Puredux.Internal.Types

-- here are our first actions
data Login
  = StartLogin String String
  | Logout
  | LoginSuccess

instance hasLabelLogin :: HasLabel Login "login" 

type LoginAction r
  = Variant (login :: Login | r)

loginReducer 
  :: forall r. Reducer (LoginAction r) Login State 
loginReducer dispatch (StartLogin _ _) s = do
  _ <- T.setTimeout 2000 do
    dispatch (liftAction' LoginSuccess)
  pure $ s { loggedIn = false, loggingIn = true }

loginReducer _ Logout s
  = pure $ s { loggedIn = false, loggingIn = false }
loginReducer _ LoginSuccess s
  = pure $ s { loggedIn = true, loggingIn = false }
