# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(weird_library VERSION 0.0.1 LANGUAGES C)

add_library(weird SHARED
  "weird.c"
)

set_target_properties(weird PROPERTIES
  PUBLIC_HEADER weird.h
  OUTPUT_NAME "weird"
)

target_compile_definitions(weird PUBLIC DART_SHARED_LIB)
