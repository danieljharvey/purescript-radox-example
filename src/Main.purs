module Main where

import Prelude (Unit, bind, pure, void, ($))
import Effect (Effect)

import Data.Maybe (fromJust)

import Web.HTML.HTMLDocument (toNonElementParentNode) as DOM
import Web.DOM.NonElementParentNode (getElementById) as DOM
import Web.HTML (window) as DOM
import Web.HTML.Window (document) as DOM

import Partial.Unsafe (unsafePartial)

import React as React
import ReactDOM as ReactDOM

import App.Data.RootReducer (reducer)
import App.Components.Homepage (homepage)

import StyleProvider

main :: Effect Unit
main = void $ do
  window <- DOM.window
  document <- DOM.document window

  let
      node = DOM.toNonElementParentNode document

  element <- DOM.getElementById "example" node

  let
      element' = unsafePartial (fromJust element)

  ReactDOM.render (React.createLeafElement app { }) element'

-- this app just sets up the Puredux Provider, which allows everything within 
-- to access the store data
app :: React.ReactClass { }
app = React.component "Main" component
  where
    component this' = do
        pure $ { state: { }
               , render: pure render'
               }
    render'  
      = React.createLeafElement reducer.provider
          { children: [ React.createLeafElement styleContext.provider
                          { children: [ React.createLeafElement homepage { title: "Hello!" } ] }
                      ]
          }
