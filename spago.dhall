{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "effect", "console", "psci-support", "js-timers", "react", "react-dom",
"web-html", "variant", "debug", "argonaut", "affjax", "generics-rep",
"argonaut-generic" ]
, packages =
    ./packages.dhall
}
