mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

@echo off
dir /s

chcp 65001
if errorlevel 1 exit 1

dir /s

cmake -GNinja ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
      -DBUILD_TESTING=ON ^
      -DCMAKE_CXX_FLAGS="/utf-8" ^
      -DCMAKE_C_FLAGS="/utf-8" ^
      ..
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1

ctest --output-on-failure
if errorlevel 1 exit 1
