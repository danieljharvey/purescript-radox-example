module App.Data.Action where

import Prelude (Unit, bind, discard, pure, unit, ($))
import Data.Either (Either(..))
import Data.Argonaut.Decode (decodeJson)
import Effect (Effect)
import Effect.Aff (launchAff)
import Effect.Class (liftEffect)
import Effect.Timer (setTimeout)

import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat

import App.Data.RootReducer (LiftedAction)
import App.Data.DogReducer (Dogs(..))
import App.Data.LoginReducer (Login(..))
import App.Data.Types (DogResponse)
import Radox

endpoint :: String
endpoint = "https://dog.ceo/api/breeds/image/random"

-- we've avoided having our reducers doing any side effects,
-- so how do we *do* things?
-- since we are able to do Effect things in event handlers
-- let's make Actions that take the dispatch function and use it
-- to save things in the store as we go

-- this gets a nice dog picture
fetchImage :: (LiftedAction -> Effect Unit) -> Effect Unit
fetchImage dispatch = do
  dispatch (lift LoadNewDog)
  _ <- launchAff $ do
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
  pure unit

-- this does a mock login
-- demonstrating we don't need Aff if we don't want to
-- do anything complicated
login 
  :: (LiftedAction -> Effect Unit)
  -> String
  -> String
  -> Effect Unit
login dispatch username password = do
  dispatch (lift (StartLogin username password))
  _ <- setTimeout 2000 (dispatch (lift LoginSuccess))
  pure unit
