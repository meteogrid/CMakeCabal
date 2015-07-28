include (FindPackageHandleStandardArgs)
include (HaskellUtil)

find_haskell_program (cabal)

find_package_handle_standard_args (Cabal
"Couldn't find the required version of cabal. You can update cabal by running 'cabal update' and then 'cabal install cabal-install'. If the right version of cabal is already installed but wasn't found, you can specify the directory where it is located via the environment variable CABAL_PATH"
    Haskell_CABAL_EXECUTABLE CABAL_VERSION)

mark_as_advanced (Haskell_CABAL_EXECUTABLE)
