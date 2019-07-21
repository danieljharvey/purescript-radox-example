module App.Components.Homepage where

import Prelude (Unit, pure, ($))
import Effect (Effect)
import React.DOM.Props as Props
import React as React
import React.DOM as RDom

import App.Data.ActionTypes (Dogs(..), LiftedAction)
import App.Data.RootReducer (reducer)
import App.Data.Types (DogState(..), State)
import Radox (lift)
import Radox.React

import App.Components.Iterator (iterator)
import App.Components.Login (login)

type HomepageProps
  = { title :: String }

homepage :: React.ReactClass HomepageProps
homepage = React.component "homepage" component
  where
    component this = do
          pure $ { state: { }
                 , render: 
                    reducer.consumer this render 
                 }

render 
  :: ReactRadoxRenderMethod HomepageProps State {} LiftedAction
render all@{ dispatch, state, props } =
  let iterator' = React.createLeafElement iterator 
                    { value: state.value
                    , dispatch: dispatch
                    }
      login' = React.createLeafElement login
                    { loggedIn: state.loggedIn
                    , loggingIn: state.loggingIn
                    , dispatch: dispatch
                    }
  in 
  RDom.div [] [ iterator'
              , login'
              , dogPicture dispatch state
              ]

dogPicture 
  :: (LiftedAction -> Effect Unit) 
  -> State 
  -> React.ReactElement
dogPicture dispatch state
  = RDom.div [] [ fetchButton, image ]
  where
    fetchButton
      = RDom.button
          [ Props.onClick (\_ -> dispatch $ lift $ LoadNewDog ) ]
          [ RDom.text "fetch!" ]
    image
      = case state.dog of
          NotTried -> RDom.div [] []
          LookingForADog -> RDom.div [] [ RDom.text "Fetching..." ]
          FoundADog url -> RDom.div [] [ RDom.img [ Props.src url ] ]
          CouldNotFindADog -> RDom.div [] [ RDom.text "Sorry, could not find a good boy" ]
