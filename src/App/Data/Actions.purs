module App.Data.Action where

import Prelude
import Data.Either (Either(..))
import Data.Argonaut.Decode (decodeJson)
import Effect (Effect)
import Effect.Aff (launchAff)
import Effect.Class (liftEffect)
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat

import App.Data.RootReducer (LiftedAction)
import App.Data.DogReducer (Dogs(..))
import App.Data.Types (DogResponse)
import Puredux (liftAction')

endpoint :: String
endpoint = "https://dog.ceo/api/breeds/image/random"

fetchImage :: (LiftedAction -> Effect Unit) -> Effect Unit
fetchImage dispatch = do
  dispatch (liftAction' LoadNewDog)
  _ <- launchAff $ do
    res1 <- AX.get ResponseFormat.json endpoint
    case res1.body of
      Left err 
        -> liftEffect $ dispatch (liftAction' $ DogError (AX.printResponseFormatError err))
      Right json 
        -> case (decodeJson json :: Either String DogResponse) of
             Left e 
                -> liftEffect $ dispatch (liftAction' $ DogError e)
             Right dog
                -> liftEffect $ dispatch (liftAction' (GotNewDog dog.message)) 
  pure unit     
