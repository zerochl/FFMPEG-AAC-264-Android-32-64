# source code: git clone https://android.googlesource.com/platform/external/aac
cmake_minimum_required ( VERSION 2.8 )

if (CMAKE_SYSTEM_NAME STREQUAL Android )
    if ( NOT CMAKE_SYSTEM_PROCESSOR )
        set ( CMAKE_SYSTEM_PROCESSOR    armeabi-v7a )
    endif ()
    if ( NOT CMAKE_SYSTEM_VERSION )
        set ( CMAKE_SYSTEM_VERSION      8 )
    endif ()
    if ( NOT NDK_TOOLCHAIN_VERSION) 
        set ( NDK_TOOLCHAIN_VERSION     4.8 )
    endif ()

    set ( ANDROID_NDK_ROOT $ENV{ANDROID_NDK_ROOT} )

    find_path ( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-${NDK_TOOLCHAIN_VERSION}/prebuilt/* )

    include ( CMakeForceCompiler )

    find_program ( CMAKE_C_COMPILER   arm-linux-androideabi-gcc PATHS ${TOOLCHAIN_ROOT}/bin )
    find_program ( CMAKE_CXX_COMPILER arm-linux-androideabi-g++ PATHS ${TOOLCHAIN_ROOT}/bin )
    find_program ( CMAKE_AR           arm-linux-androideabi-ar  PATHS ${TOOLCHAIN_ROOT}/bin )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-${CMAKE_SYSTEM_VERSION}/arch-arm  CACHE PATH "" )

    set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
    set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
    set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )

endif ()

project ( fdk-aac )

if ( NOT INCLUDE_INSTALL_DIR )
    set ( INCLUDE_INSTALL_DIR include )
endif ()

if ( NOT ARCHIVE_INSTALL_DIR )
    set ( ARCHIVE_INSTALL_DIR lib/static )
endif ()

if ( NOT IS_DIRECTORY ${FDK_AAC_SOURCE_DIR} )
    message ( FATAL_ERROR "FDK_AAC_SOURCE_DIR=${FDK_AAC_SOURCE_DIR} is not a dir" )
endif ()

if ( CMAKE_SYSTEM_NAME STREQUAL Android )
    add_definitions (
        --sysroot=${CMAKE_SYSROOT}
        -fPIC
        -march=armv7-a
        -mfpu=vfpv3-d16
        -DANDROID
        -mhard-float
        -D_NDK_MATH_NO_SOFTFP=1
        -lm_hard )
endif ()

add_definitions (
    -fno-rtti
    -fno-exceptions )

set ( SOURCE_FILES )

foreach ( subdir
    libAACdec libAACenc libFDK
    libMpegTPDec libMpegTPEnc
    libPCMutils
    libSBRdec libSBRenc
    libSYS )

    set ( __inc_dir ${FDK_AAC_SOURCE_DIR}/${subdir}/include )

    include_directories ( ${__inc_dir} )
    install ( DIRECTORY ${__inc_dir}/ DESTINATION ${INCLUDE_INSTALL_DIR}/fdk-aac/ )

    file ( GLOB __src_files
        ${FDK_AAC_SOURCE_DIR}/${subdir}/src/*.cpp
        ${FDK_AAC_SOURCE_DIR}/${subdir}/src/*.h )
    list ( APPEND SOURCE_FILES ${__src_files} )
endforeach ()

add_library ( fdk-aac STATIC
    ${SOURCE_FILES} )

install ( TARGETS fdk-aac
    ARCHIVE DESTINATION ${ARCHIVE_INSTALL_DIR} )