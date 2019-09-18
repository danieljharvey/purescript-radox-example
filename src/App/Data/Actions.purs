module App.Data.Actions where

import Prelude (Unit, bind, pure, unit, ($))
import Data.Either (Either(..))
import Data.Argonaut.Decode (decodeJson)
import Effect (Effect)
import Effect.Aff (Aff) 
import Effect.Class (liftEffect)
import Effect.Timer (setTimeout)

import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat

import App.Data.ActionTypes (Dogs(..), LiftedAction, Login(..))
import App.Data.Types (DogResponse)
import Radox

endpoint :: String
endpoint = "https://dog.ceo/api/breeds/image/random"

-- since we are able to do Effect things in event handlers
-- let's make Actions that take the dispatch function and use it
-- to save things in the store as we go

-- this gets a nice dog picture
fetchImage :: (LiftedAction -> Effect Unit) -> Aff Unit
fetchImage dispatch = do
  res1 <- AX.get ResponseFormat.json endpoint
  case res1.body of
    Left err 
      -> liftEffect $ dispatch (lift $ DogError (AX.printResponseFormatError err))
    Right json 
      -> case (decodeJson json :: Either String DogResponse) of
           Left e 
              -> liftEffect $ dispatch (lift $ DogError e)
           Right dog
              -> liftEffect $ dispatch (lift (GotNewDog dog.message)) 

-- this does a mock login
-- demonstrating we don't need Aff if we don't want to
-- do anything complicated
login 
  :: (LiftedAction -> Effect Unit)
  -> String
  -> String
  -> Aff Unit
login dispatch username password = do
  _ <- liftEffect $ setTimeout 2000 (dispatch (lift LoginSuccess))
  pure unit
