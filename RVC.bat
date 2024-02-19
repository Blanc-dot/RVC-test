@echo off

:: Set the name of your virtual environment folder
set VENV_DIR=%~dp0\rvc\venv\
set REPO_DIR=%~dp0\rvc\
set REPO_URL=https://github.com/Enrop/RVC-test



:download
cd %REPO_DIR%
if exist %REPO_DIR% (
    echo "'%REPO_DIR%' already exists. Updating..."
    git pull
    if %ERRORLEVEL% NEQ 0 (
        pause
    )
) else (
    echo "Directory '%REPO_DIR%' does not exist. Cloning repository..."
	git clone %REPO_URL% rvc
    if %ERRORLEVEL% NEQ 0 (
        pause
    ) 
)



:venv
if exist %VENV_DIR% (
    echo "Virtual environment '%VENV_DIR%' already exists. Activating..."
    call %VENV_DIR%\Scripts\activate.bat
) else (
    echo "Virtual environment '%VENV_DIR%' not found. Creating..."
    python -m venv %VENV_DIR%
    if %ERRORLEVEL% NEQ 0 (
        echo "Error creating virtual environment. Please check your Python installation."
        pause
        exit /B 1
    )
    echo "Virtual environment created successfully. Activating..."
    call %VENV_DIR%\Scripts\activate.bat
)

set /P "Q=Is this your first time running? (y/n): "
if /I "%Q%" == "y" goto requirements
if /I "%Q%" == "Y" goto requirements

REM If %Q% is not "y" or "Y", go to start
goto start

:requirements
call %VENV_DIR%\Scripts\activate.bat
cd %REPO_DIR%
python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
python -m pip install fairseq==0.12.2
python -m pip install -r requirements.txt
python tools/download_models.py



:start
call %VENV_DIR%\Scripts\activate.bat
cd %REPO_DIR%
python infer-web.py
