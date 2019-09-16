module App.Data.DogReducer where

import Prelude (($))
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
            let newAction = fetchImage dispatch
                newState = state { dog = LookingForADog }
            UpdateStateAndRunEffect newState newAction
      GotNewDog url
        -> UpdateState $ state { dog = (FoundADog url) }
      DogError e
        -> UpdateState $ state { dog = CouldNotFindADog } 
