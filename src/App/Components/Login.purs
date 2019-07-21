module App.Components.Login where

import Prelude (Unit, bind, otherwise, pure, ($), (<>), (==))
import Effect (Effect)
import Data.Array (intercalate)
import Data.Functor (map)
import React.DOM.Props as Props
import React as React
import React.DOM as RDom

import App.Data.Actions (login) as Action
import App.Data.ActionTypes (LiftedAction, Login(..))
import Radox (lift)

import App.Components.Styled.Div (div)

import PursUI 

type LoginProps
  = { loggedIn :: Boolean
    , loggingIn :: Boolean
    , dispatch :: (LiftedAction -> Effect Unit)
    }

toClassNames :: Array CSSSelector -> String
toClassNames as
  = intercalate " " $ map unwrap as
  where
    unwrap (CSSClassSelector s) = s

loginStyle :: CSSRuleSet LoginProps
loginStyle
  =  str """
       font-size: 16px;
       line-height: 1.5;
       border: 1px solid red;
       padding: 20px;
     """
  <> fun (\i -> if i.loggingIn 
                then "background-color: blue;"
                else "background-color: white;")
  <> fun (\j -> if j.loggedIn
                then "color: green;"
                else "color: black;")

greyBox 
  :: forall a
   . a 
  -> Array React.ReactElement 
  -> React.ReactElement
greyBox 
  = div 
      (str """
        border: solid 1px darkgrey;
        background-color: lightgrey;
        """
      ) 

highlightBox
  :: forall a
   . { highlight :: Boolean | a }
  -> Array React.ReactElement
  -> React.ReactElement
highlightBox
  = div 
      (  str 
          """
          background-color: lightgrey; 
          line-height: 1.5;
          """
      <> fun (\i -> if i.highlight
                then "border: 3px solid green;"
                else "border: 1px solid darkgrey;"
             )
      )

login :: React.ReactClass LoginProps
login = React.component "login" component
  where
    component this = do
          (stylesheet :: PursUI "poo2") <- createBlankStyleSheet 
          pure $ { state: { }
                 , render: do
                    props <- React.getProps this
                    classes <- addStyle stylesheet loginStyle props
                    pure (renderLogin classes props)
                 }
    renderLogin classes props
     = greyBox {} [ button, label ]
      where
        button 
          = RDom.button 
              [ Props.className (toClassNames classes)
              , Props.onClick (\_ 
                  -> do
                    if props.loggedIn == false
                      then
                        Action.login props.dispatch "Hello" "World"
                      else
                        props.dispatch (lift Logout)) 
              ] 
              [ RDom.text (if props.loggedIn then "Logout" else "Login" )] 
        label 
          = highlightBox { highlight: props.loggedIn }
            [ RDom.p [] [ RDom.text (buttonText props) ] ]

buttonText 
  :: LoginProps 
  -> String
buttonText props
  | props.loggedIn == true = "Logged in!"
  | props.loggingIn == true = "Logging in..."
  | otherwise = "Not logged in"
