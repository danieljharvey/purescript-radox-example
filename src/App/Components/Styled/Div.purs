module App.Components.Styled.Div (div) where

import Prelude (bind, pure, ($))
import Data.Array (intercalate)
import Data.Functor (map)
import React.DOM.Props as Props
import React as React
import React.DOM as RDom

import PursUI (CSSRuleSet, CSSSelector(..), PursUI, addStyle, createBlankStyleSheet)

div 
  :: forall props 
   . CSSRuleSet props 
  -> props 
  -> Array React.ReactElement 
  -> React.ReactElement
div createStyle props children
  = React.createLeafElement div'
      { createStyle: createStyle
      , props: props
      , children: children
      }

div_ :: forall props. CSSRuleSet props -> props -> React.ReactElement
div_ createStyle props 
  = div createStyle props [] 

div' 
  :: forall props 
   . React.ReactClass { createStyle :: CSSRuleSet props
                      , props :: props
                      , children :: Array React.ReactElement  
                      }
div' = React.component "div" component
    where
      component this = do
        (stylesheet :: PursUI "divshit") <- createBlankStyleSheet 
        pure $ { state: { }
               , render: do
                   props <- React.getProps this
                   classes <- addStyle stylesheet props.createStyle props.props
                   pure 
                    $ RDom.div 
                        [ Props.className (toClassNames classes) ]
                        props.children
               }

toClassNames :: Array CSSSelector -> String
toClassNames as
  = intercalate " " $ map unwrap as
  where
    unwrap (CSSClassSelector s) = s
