include (FindPackageHandleStandardArgs)
include (HaskellUtil)

find_haskell_program (ghc)

find_package_handle_standard_args (GHC
  "Couldn't find the required version of ghc. You can install ghc with Haskell Platform (https://www.haskell.org/platform/). If the right version of ghc is already installed but wasn't found, you can specify the directory where it is located via the environment variable GHC_PATH"
Haskell_GHC_EXECUTABLE GHC_VERSION)

get_filename_component(Haskell_GHC_DIR ${Haskell_GHC_EXECUTABLE} DIRECTORY CACHE)

mark_as_advanced (Haskell_GHC_EXECUTABLE)
