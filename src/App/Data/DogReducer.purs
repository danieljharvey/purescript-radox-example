module App.Data.DogReducer where

import Prelude (discard, pure, ($))
import App.Data.Actions (fetchImage)
import App.Data.ActionTypes (Dogs(..), LiftedAction)
import App.Data.Types (DogState(..), State)

import Radox

-- ahoy, here is a reducer that is in charge of the data side of
-- fetching dog pictures. The actual AJAX stuff etc lives in the Actions
-- file

dogReducer 
  :: EffectfulReducer Dogs State LiftedAction
dogReducer { dispatch } action state
  = case action of
      LoadNewDog 
        -> do
          fetchImage dispatch
          pure $ state { dog = LookingForADog }
      GotNewDog url
        -> pure $ state { dog = (FoundADog url) }
      DogError e
        -> pure $ state { dog = CouldNotFindADog } 
