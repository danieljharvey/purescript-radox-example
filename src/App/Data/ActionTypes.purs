module App.Data.ActionTypes where

import Data.Variant (Variant)
import Radox

-- here are our first actions
data Login
  = StartLogin String String
  | Logout
  | LoginSuccess

instance hasLabelLogin :: HasLabel Login "login" 


data Dogs
  = LoadNewDog
  | GotNewDog String
  | DogError String

instance hasLabelDogs :: HasLabel Dogs "dogs"

-- here are our second actions
data Counting
  = Up
  | Down

instance hasLabelCounting :: HasLabel Counting "counting"

type LiftedAction 
  = Variant ( login :: Login
            , counting :: Counting
            , dogs :: Dogs
            )

