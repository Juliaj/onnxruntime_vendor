cmake_minimum_required(VERSION 3.10)
project(onnxruntime_vendor)

find_package(ament_cmake REQUIRED)
include(FetchContent)

set(ORT_VERSION "1.24.3")
set(ORT_DOWNLOAD_URL "https://github.com/microsoft/onnxruntime/releases/download/v${ORT_VERSION}")

# Detect system and architecture for appropriate asset selection (ROS 2 distro platforms)
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|ARM64")
    set(ORT_ASSET_NAME "onnxruntime-linux-aarch64-${ORT_VERSION}.tgz")
  elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    set(ORT_ASSET_NAME "onnxruntime-linux-x64-${ORT_VERSION}.tgz")
  else()
    message(FATAL_ERROR "Unsupported Linux architecture: ${CMAKE_SYSTEM_PROCESSOR}")
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  message(FATAL_ERROR "onnxruntime_vendor: macOS (Darwin) is not supported.")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  message(FATAL_ERROR "onnxruntime_vendor: Windows is not supported.")
else()
  message(FATAL_ERROR "Unsupported operating system: ${CMAKE_SYSTEM_NAME}")
endif()

set(ORT_ASSET_URL "${ORT_DOWNLOAD_URL}/${ORT_ASSET_NAME}")

message(STATUS "Downloading ONNX Runtime prebuilt binary: ${ORT_ASSET_NAME}")

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

# Copy to a stable, version-named directory so cmake_install.cmake does not
# reference FetchContent _deps/ path (e.g. for Debian packaging).
set(ONNXRUNTIME_ROOT_DIR "${CMAKE_BINARY_DIR}/onnxruntime_prebuilt_${ORT_VERSION}")
if(NOT EXISTS "${ONNXRUNTIME_ROOT_DIR}")
  file(COPY "${onnxruntime_binary_SOURCE_DIR}/" DESTINATION "${ONNXRUNTIME_ROOT_DIR}")
endif()

install(DIRECTORY "${ONNXRUNTIME_ROOT_DIR}/include/"
  DESTINATION opt/${PROJECT_NAME}/include
)

install(DIRECTORY "${ONNXRUNTIME_ROOT_DIR}/lib/"
  DESTINATION opt/${PROJECT_NAME}/lib
  FILES_MATCHING
  PATTERN "*"
)

ament_package(
  CONFIG_EXTRAS_POST "onnxruntime_vendor-extras.cmake"
)