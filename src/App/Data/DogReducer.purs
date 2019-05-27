module App.Data.DogReducer where

import App.Data.Types (DogState(..), State)
import Radox

-- ahoy, here is a reducer that is in charge of the data side of
-- fetching dog pictures. The actual AJAX stuff etc lives in the Actions
-- file

data Dogs
  = LoadNewDog
  | GotNewDog String
  | DogError String

instance hasLabelDogs :: HasLabel Dogs "dogs"

dogReducer 
  :: Reducer Dogs State 
dogReducer LoadNewDog s
  = s { dog = LookingForADog }
dogReducer (GotNewDog url) s
  = s { dog = (FoundADog url) }
dogReducer (DogError e) s
  = s { dog = CouldNotFindADog } 
