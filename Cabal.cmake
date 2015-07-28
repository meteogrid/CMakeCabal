function (add_cabal_build)
  set (multiValueArgs EXECUTABLES SOURCES SANDBOX_SOURCES DEPENDS)
    cmake_parse_arguments (arg "${flagArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    foreach(executable ${arg_EXECUTABLES})
      add_custom_command (
        DEPENDS ${PROJECT_NAME}_build
        COMMAND ${CMAKE_COMMAND} -E rename
            ${CMAKE_CURRENT_BINARY_DIR}/build/${executable}/${executable}${CMAKE_EXECUTABLE_SUFFIX}
            ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${executable}${CMAKE_EXECUTABLE_SUFFIX}
        OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${executable}${CMAKE_EXECUTABLE_SUFFIX})
      add_custom_target (${executable} ALL
          SOURCES ${arg_SOURCES}
          DEPENDS ${arg_DEPENDS} 
                  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${executable}${CMAKE_EXECUTABLE_SUFFIX})
      install (PROGRAMS
        ${CMAKE_CURRENT_BINARY_DIR}/build/${executable}/${executable}${CMAKE_EXECUTABLE_SUFFIX}
        DESTINATION bin)
    endforeach(executable)

    add_custom_command (
      DEPENDS ${arg_SOURCES} ${arg_DEPENDS} ${CMAKE_BINARY_DIR}/cabal.sandbox.config
      COMMAND PATH=${Haskell_GHC_DIR} ${Haskell_CABAL_EXECUTABLE} sandbox init --sandbox=${CMAKE_BINARY_DIR}/.cabal-sandbox
      COMMAND PATH=${Haskell_GHC_DIR} ${Haskell_CABAL_EXECUTABLE} sandbox add-source ${arg_SANDBOX_SOURCES}
      COMMAND ${Haskell_CABAL_EXECUTABLE} install --with-ghc=${Haskell_GHC_EXECUTABLE} --extra-prog-path=$ENV{HOME}/.cabal/bin --only-dependencies --jobs
      COMMAND ${Haskell_CABAL_EXECUTABLE} configure --with-ghc=${Haskell_GHC_EXECUTABLE} --builddir=${CMAKE_CURRENT_BINARY_DIR}
      COMMAND ${Haskell_CABAL_EXECUTABLE} build --with-ghc=${Haskell_GHC_EXECUTABLE} --ghc-option=-O2 --jobs --builddir=${CMAKE_CURRENT_BINARY_DIR}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/build-stamp)

    add_custom_target (${PROJECT_NAME}_build DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/build-stamp)
endfunction()    


add_custom_command(
  COMMAND PATH=${Haskell_GHC_DIR} ${Haskell_CABAL_EXECUTABLE} sandbox init
  COMMAND PATH=${Haskell_GHC_DIR} ${Haskell_CABAL_EXECUTABLE} update
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  OUTPUT ${CMAKE_BINARY_DIR}/cabal.sandbox.config)
