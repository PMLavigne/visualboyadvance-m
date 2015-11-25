#
# Find script for the ispc (Intel SPMD Program Compiler) command. More info:
# https://ispc.github.io/
#
# Design of this script was heavily influenced by Roberto Vitillo's similar script, which can be found here:
# https://github.com/vitillo/ispc_template/blob/master/FindISPC.cmake
#
cmake_minimum_required(VERSION 3.2)
message(STATUS "Checking for ispc...")

# Check if it was specified already
if(NOT EXISTS "${ISPC_COMMAND}")
    find_program(ISPC_COMMAND ispc)
    if("${ISPC_COMMAND}" MATCHES "ISPC_COMMAND-NOTFOUND")
        message(FATAL_ERROR "The program 'ispc' is not installed, please visit https://ispc.github.io/ for install instructions")
    endif()
endif()

message(STATUS "Using '${ISPC_COMMAND}' for 'ispc'")

set(ISPC_INSTRUCTION_SET "avx1" CACHE STRING "ispc instruction set to use, specific to your CPU")
set(ISPC_MASK_SIZE "32" CACHE STRING "ispc execution mask size")
set(ISPC_GANG_SIZE "16" CACHE STRING "ispc execution gang size")
set(ispc_target_string "${ISPC_INSTRUCTION_SET}-i${ISPC_MASK_SIZE}x${ISPC_GANG_SIZE}")


set(ISPC_FLAGS "" CACHE STRING "ispc compiler flags")
set(ISPC_FLAGS_DEBUG "-g -O0" CACHE STRING "ispc compiler flags (debug mode)")
set(ISPC_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "ispc compiler flags (release mode)")

function(ispc_compile filename objVarName)
    get_filename_component(basename "${filename}" NAME_WE)
    set(obj "${basename}.o")
    set(objFile "${CMAKE_CURRENT_BINARY_DIR}/ispc_output/${obj}")
    set(header "${basename}.h")
    set(headerFile "${CMAKE_CURRENT_BINARY_DIR}/ispc_output/include/ispc/${header}")

    set(compile_flags "--target=${ispc_target_string} ${ISPC_FLAGS}")
    if("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
        set(compile_flags "${compile_flags} ${ISPC_FLAGS_DEBUG}")
    elseif("${CMAKE_BUILD_TYPE}" MATCHES "Release")
        set(compile_flags "${compile_flags} ${ISPC_FLAGS_RELEASE}")
    endif()
    string(REPLACE " " ";" compile_flags_list ${compile_flags})

    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/ispc_output/include/ispc/")

    add_custom_command(OUTPUT "${objFile}" "${headerFile}"
                       BYPRODUCTS "${objFile}" "${headerFile}"
                       COMMENT "Compiling ${filename}"
                       DEPENDS ${filename}
                       COMMAND ${ISPC_COMMAND} ${compile_flags_list} ${filename} -o ${objFile} -h ${headerFile})
    set(${objVarName} ${objFile} PARENT_SCOPE)
endfunction()
