@echo off
setlocal

REM Define the directory for the virtual environment
set venv_dir=%~dp0\tensorboard_venv

REM Check if tensorboard_venv exists in the root directory
if not exist "%venv_dir%\" (
    REM Print the step to the terminal
    echo Installing virtualenv...

    REM Install virtualenv
    python -m pip install virtualenv

    REM Print the step to the terminal
    echo Creating a virtual environment named tensorboard_venv...

    REM Create a virtual environment named tensorboard_venv in the root directory
    python -m virtualenv "%venv_dir%"

    REM Print the step to the terminal
    echo Activating the virtual environment...

    REM Activate the virtual environment
    call "%venv_dir%\Scripts\activate"

    REM Print the step to the terminal
    echo Installing TensorBoard into the virtual environment...

    REM Install TensorBoard into the virtual environment
    pip install tensorboard

    REM Downgrade problematic packages
    echo Downgrading packages for troubleshooting...
    pip install markdown==3.0 tensorboard==2.1.0 protobuf==3.11.0 numpy==1.19.5

) else (
    REM Print the step to the terminal
    echo tensorboard_venv already exists, skipping creation and activation...

    REM Activate the existing virtual environment
    call "%venv_dir%\Scripts\activate"
)

REM Print the step to the terminal
echo Launching TensorBoard...

REM Launch TensorBoard
tensorboard --logdir="%~dp0\logs"

REM Print the step to the terminal
echo Keeping the command prompt open...

pause
endlocal
