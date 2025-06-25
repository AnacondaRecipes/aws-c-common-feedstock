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

@REM aws_fopen_non_ascii_read_existing_file_test: Failed to open file. path:'A example.txt' mode:'r' errno:2 aws-error:44(Unknown Error Code)
@REM Upstream has file name with special characters https://github.com/awslabs/aws-c-common/blob/main/tests/resources/%C3%85%20%C3%89xample.txt
@REM Setting UTF-8 doesn't help, name is changed after upstream source code unpacking.
ctest -E "aws_fopen_non_ascii_read_existing_file_test" --output-on-failure
if errorlevel 1 exit 1
