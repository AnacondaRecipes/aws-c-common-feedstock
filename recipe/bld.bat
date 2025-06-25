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

@REM aws_fopen_non_ascii_read_existing_file_test: Failed to open file. path:'Ã… Ã‰xample.txt' mode:'r' errno:2 aws-error:44(Unknown Error Code)
@REM Upstream has file name with special characters 'Å Éxample.txt' https://github.com/awslabs/aws-c-common/blob/main/tests/resources/%C3%85%20%C3%89xample.txt
@REM Unicode vs UTF-8 encoding issue
ctest -E "aws_fopen_non_ascii_read_existing_file_test" --output-on-failure
if errorlevel 1 exit 1
