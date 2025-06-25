dir /s

chcp 65001
if errorlevel 1 exit 1

dir /s

mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

cmake -GNinja ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
      -DBUILD_TESTING=ON ^
      ..
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1

REM Encoding issue, setting UTF-8 doesn't help, "Å Éxample.txt" is correct name in upstream, fix for test:
REM aws_fopen_non_ascii_read_existing_file_test: static: Failed to open file. path:'Å Éxample.txt'
RENAME "%SRC_DIR%\tests\resources\├à ├ëxample.txt" "Å Éxample.txt"
if errorlevel 1 exit 1

ctest --output-on-failure
if errorlevel 1 exit 1
