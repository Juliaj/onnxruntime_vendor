cmake_minimum_required(VERSION 3.10)
project(onnxruntime_vendor)

find_package(ament_cmake REQUIRED)
include(FetchContent)

set(ORT_VERSION "1.21.0")

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux")
  message(FATAL_ERROR "onnxruntime_vendor currently supports only Linux.")
endif()

if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
  message(FATAL_ERROR "onnxruntime_vendor currently supports only x86_64/AMD64.")
endif()

set(ORT_ASSET_NAME "onnxruntime-linux-x64-${ORT_VERSION}.tgz")
set(ORT_ASSET_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ORT_VERSION}/${ORT_ASSET_NAME}")

if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.24")
  set(_onnxruntime_timestamp DOWNLOAD_EXTRACT_TIMESTAMP TRUE)
endif()

FetchContent_Declare(
  onnxruntime_binary
  URL "${ORT_ASSET_URL}"
  # TODO: optionally add URL_HASH SHA256=<known_sha256>
  ${_onnxruntime_timestamp}
)
FetchContent_MakeAvailable(onnxruntime_binary)

set(ONNXRUNTIME_ROOT_DIR "${onnxruntime_binary_SOURCE_DIR}")

install(DIRECTORY "${ONNXRUNTIME_ROOT_DIR}/include/"
  DESTINATION opt/${PROJECT_NAME}/include
)

install(DIRECTORY "${ONNXRUNTIME_ROOT_DIR}/lib/"
  DESTINATION opt/${PROJECT_NAME}/lib
)

ament_package(
  CONFIG_EXTRAS_POST "onnxruntime_vendor-extras.cmake"
)