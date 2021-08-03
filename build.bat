@echo off

echo "Compile script for pweave noweb documents (.pnw) under Windows OS"
echo "Requires a LaTeX installation"
echo "Requires a Python installation in form of anaconda/miniconda distribution in user directory"
echo "Requires a creation of Python virtual environment with name 'pweave'"
echo "Requires conda package installation with name 'pweave' (within the environment)"
echo "Usage example, e.g.: build.bat test.pnw"

set filename=%1
set filenamenoext=%~n1
REM It is recommended that you install anaconda in user directory
REM To adjust to your system setup, in the path string below, replace 'yourusername' with your own
REM and make a correction to anaconda path
set pathtoanaconda="C:\Users\yourusername\anaconda3"

echo "Compiling ...%filename%"

echo "activativating conda pweave environment and compiling by pweave ..."

CALL "%pathtoanaconda:"=%\Scripts\activate.bat" pweave 

"%pathtoanaconda:"=%\envs\pweave\Scripts\pweave.exe" -f tex %filename%

echo "compiling %filenamenoext%.tex by pdflatex ... into %filenamenoext%.pdf"

REM In this script, a pdflatex is called, change it according to your TeX engine
pdflatex -synctex=1 -interaction=nonstopmode %filenamenoext%.tex
pdflatex -synctex=1 -interaction=nonstopmode %filenamenoext%.tex

CALL "%pathtoanaconda:"=%\condabin\conda.bat" deactivate

echo "Complete"
