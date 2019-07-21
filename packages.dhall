let mkPackage =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.2-20190715/src/mkPackage.dhall sha256:0b197efa1d397ace6eb46b243ff2d73a3da5638d8d0ac8473e8e4a8fc528cf57

let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.2-20190715/src/packages.dhall sha256:906af79ba3aec7f429b107fd8d12e8a29426db8229d228c6f992b58151e2308e

let overrides = {=}

let additions =
      { radox =
          mkPackage
          [ "prelude", "console", "effect", "variant", "refs" ]
          "https://github.com/danieljharvey/purescript-radox.git"
          "v0.0.8"
      , react-radox =
          mkPackage
          [ "prelude", "console", "effect", "radox", "react" ]
          "https://github.com/danieljharvey/purescript-react-radox.git"
          "v0.0.4"
      , cssom =
          mkPackage
          [ "effect", "console" ]
          "https://github.com/danieljharvey/purescript-cssom.git"
          "v0.0.2"
      , styling =
          mkPackage
          [ "console"
          , "debug"
          , "effect"
          , "foreign"
          , "generics-rep"
          , "ordered-collections"
          , "prelude"
          , "psci-support"
          , "refs"
          , "test-unit"
          , "unordered-collections"
          , "cssom"
          ]
          "../purs-cssom"
          "v0.0.1"
      }

in  upstream // overrides // additions
