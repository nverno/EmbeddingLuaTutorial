cmake_minimum_required(VERSION 3.7)

project(LuaTutorial)

# so we can add the LUA_TUTORIAL_DEBUG preprocessor define and other flags to
# stay in debug mode - see
# https://cmake.org/Wiki/CMake_Useful_Variables#Compilers_and_Tools
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DLUA_TUTORIAL_DEBUG")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -DLUA_TUTORIAL_DEBUG")

if(MSVC)
  add_compile_options(/MP)               # Use multiple processors when building
  add_compile_options(/W4 /wd4201 /WX)   # Warning level 4, all warnings are errors
else()
  add_compile_options(-W -Wall -Werror)  # All Warnings, all warnings are errors
endif()

# source for the test executable
file(GLOB LUA_TUTORIAL_SOURCES RELATIVE ${PROJECT_SOURCE_DIR} "*.cpp" "*.h")
		
add_executable(tutorial ${LUA_TUTORIAL_SOURCES})

target_link_libraries(tutorial PUBLIC LuaLib)

find_package(RTTR CONFIG REQUIRED Core)
target_link_libraries(tutorial PUBLIC RTTR::Core_Lib) # rttr as static library
