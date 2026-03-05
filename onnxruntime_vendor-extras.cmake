if(NOT TARGET onnxruntime::onnxruntime)
  add_library(onnxruntime::onnxruntime SHARED IMPORTED)
  set_target_properties(onnxruntime::onnxruntime PROPERTIES
    IMPORTED_LOCATION "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/lib/libonnxruntime.so"
    INTERFACE_INCLUDE_DIRECTORIES "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/include"
    INTERFACE_LINK_OPTIONS "LINKER:-rpath,${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/lib"
  )
endif()

set(onnxruntime_vendor_LIBRARIES onnxruntime::onnxruntime)
set(onnxruntime_vendor_LIBRARY_DIRS "${onnxruntime_vendor_DIR}/../../../opt/onnxruntime_vendor/lib")