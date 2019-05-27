module App.Data.DogReducer where


import App.Data.Types (DogState(..), State)
import Puredux.Internal.Types

-- here are our second actions
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
