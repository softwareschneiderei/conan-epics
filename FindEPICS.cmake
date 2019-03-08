find_path(EPICS_INCLUDE_DIR NAMES epicsVersion.h)
find_path(EPICS_INCLUDE_OS_DIR NAMES osdEvent.h HINTS ${EPICS_INCLUDE_DIR}/os/Linux ${EPICS_INCLUDE_DIR}/os/Darwin)
find_path(EPICS_INCLUDE_COMP_DIR NAMES compilerSpecific.h HINTS ${EPICS_INCLUDE_DIR}/compiler/gcc ${EPICS_INCLUDE_DIR}/compiler/clang)

set(EPICS_INCLUDE_DIR ${EPICS_INCLUDE_DIR} ${EPICS_INCLUDE_OS_DIR} ${EPICS_INCLUDE_COMP_DIR})

set(EPICS_LIB_FILES Com ca dbCore dbRecStd nt pvAccess pvAccessCA pvAccessIOC pvData pvDatabase pvaClient qsrv)

foreach(CUR_NAME ${EPICS_LIB_FILES})
  find_library(FOUND_LIB${CUR_NAME} NAMES ${CUR_NAME} HINTS ${CONAN_LIB_DIRS_EPICS})
  set(EPICS_LIBRARIES ${EPICS_LIBRARIES} ${FOUND_LIB${CUR_NAME}})
endforeach(CUR_NAME)

set(EPICS_FOUND TRUE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EPICS DEFAULT_MSG
    EPICS_INCLUDE_DIR
    EPICS_LIBRARIES
)