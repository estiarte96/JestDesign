@echo off
echo ==========================================
echo    SUBIENDO CAMBIOS A GITHUB
echo ==========================================

:: Comprobar si existe repo
if not exist .git (
    echo [ERROR] No se ha inicializado el repositorio git.
    echo Ejecuta primero: git init
    echo Y luego vinculalo: git remote add origin TU_URL_GITHUB
    pause
    exit /b
)

echo 1. Añadiendo archivos...
git add .

echo 2. Guardando cambios (Commit)...
set /p commitMsg="Introduce mensaje del commit (Enter para usar fecha): "
if "%commitMsg%"=="" set commitMsg=Actualizacion %date% %time%
git commit -m "%commitMsg%"

echo 3. Subiendo a la nube (Push)...
git push -u origin main

if %errorlevel% neq 0 (
    echo [ERROR] Hubo un problema al subir. Verifica tu conexion o permisos.
    echo Tal vez necesites hacer 'git push -u origin master' o la rama que uses.
) else (
    echo [OK] Cambios subidos correctamente!
)

pause
