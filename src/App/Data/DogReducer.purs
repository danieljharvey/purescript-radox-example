module App.Data.DogReducer where

import Prelude (pure, ($))
import Data.Variant (Variant)

import App.Data.Types (DogState(..), State)
import Puredux.Internal.Types

-- here are our second actions
data Dogs
  = LoadNewDog
  | GotNewDog String
  | DogError String

instance hasLabelDogs :: HasLabel Dogs "dogs"

type DogAction r
  = Variant (dogs :: Dogs | r)

dogReducer 
  :: forall r. Reducer (DogAction r) Dogs State 
dogReducer _ LoadNewDog s
  = pure $ s { dog = LookingForADog }
dogReducer _ (GotNewDog url) s
  = pure $ s { dog = (FoundADog url) }
dogReducer _ (DogError e) s
  = pure $ s { dog = CouldNotFindADog } 
