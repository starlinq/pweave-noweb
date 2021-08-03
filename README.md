# Writing paper, report or presentation using Pweave noweb syntax

As soon as you know, at least to some reasoble extent, a power of LaTeX, you can extend its capabilities even to higher level. One of possible ideas is to integrate some code into your publication according to concept of literate programming.

There are many ways to do that in practice. In first, I would like to introduce you a way of integrating a Python code into LaTeX document. In second, we will talk about tools which can help us to impelement all the ideas.

We are going to use so called 'noweb' syntax for embedding Python code into LaTeX document. The 'noweb' syntax has some distinctive advantages: no need for own 'Pweave' LaTeX package installation, after Pweave pass before LaTeX compilation - final document is a vanilla TeX document, which can be compiled into PDF on any computer with only required TeX packages and user sources.

The basic noweb code chunk is marked as:

```
<<>>=
x = 987.2
x = x**2
@
```
A chunk has many optional arguments, you can find the details [here](https://mpastell.com/pweave/chunks.html).

The Pweave supports placing an inline code within markers `<% %>` and result of expression within markers `<%= %>`. The typical use of `<% %>` code markup is well illustrated importing Python packages

```
<%
import sys
from numpy import pi, linspace, sqrt, sin
%>
```

Both chunk code and inline code markers will not be included in weaved document.


If we do not consider Python installation steps, the next step is its configuration for processing Pweave documents. As base we will take a well-known Anaconda Python distribution. A typically recommended way is to create a virtual environment for running Python code:

```console
conda create --name pweave
conda install -n pweave python=3.6 
conda install -n pweave -c conda-forge pweave
conda install -n pweave pygments
conda install -n pweave numpy
```

We specified Python version 3.6, if we do not do this, the latest version will be installed.

If we exclude from our consideration very basic editors (which do not have a syntax highlighting or other conviniences), currently not some many tools are available if you want to write your Pweave document with some extra help from editor. 

A purpose of the following list is to describe Pweave-aware editors:
* [TeXstudio](https://www.texstudio.org/) (a great editor with long history of development, supports Pweave .Pnw files from default including syntax highlighting, with user command we can create commands to compile Pweave file to PDF)
* [Atom](https://atom.io/) with [Atom-LaTeX](https://atom.io/packages/atom-latex) or other LaTeX supporting package, language-weave extensions (gives a syntax highlighting)

Each editor has own specifics relating to Pweave syntax highlighting. The TeXstudio has no problem with Pweave inline code insertions into inline math equations of `$ $` syntax style (e.g. ` $ x= <%= x %> $`). 

Example of Pweave file opening in the TeXstudio is presented below: 

![ieeeaccess-pweave](https://user-images.githubusercontent.com/2492702/127107496-e10bc981-79bb-47e7-b52a-663ed6f5e239.png)

[[https://github.com/starlinq/images/blob/27b19d39193e73faa2a70f731b41322939f4ee3e/ieeeaccess-pweave.png]]




## Setting up a build command for editor

In TeXstudio we can create an user command.

To setup the user command, go to Options > Configure TeXstudio ... then select Build tab on the left. On the right pane you will see User Commands group which consists of two input fields where the leftmost is for the name of command.

The typical approach for creating user build command is to divide it into multiple commands which are required for complete task. 

Lets set it for the first command `pweave-activate:pweave-activate`. The next input field we have to populate with actual command: `"C:\Users\yourusername\anaconda3\Scripts\activate.bat" pweave` (for Windows OS). Here we activate previously created 'pweave' environment.

The second command name is `pweave:pweave` and command line is `C:\Users\yourusername\anaconda3\envs\pweave\Scripts\pweave -f tex %.Pnw`. 

The third command name is `pweave-deactivate:pweave-deactivate` and its command line is `C:\Users\yourusername\anaconda3\condabin\conda.bat deactivate`.

The final command will be `pweave-comple:pweave-compile` and `txs:///pweave-activate | txs:///pweave | txs:///pdflatex | txs:///pdflatex | txs:///pweave-deactivate`. 

Another approach is: we can combine all the commands above into single batch file for Windows OS (named as `build.bat` for reference):

```batch
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
```

In Atom a configuration for user command depends on used LaTeX extension. Here we are going to use the [Atom-LaTeX](https://atom.io/packages/atom-latex). The package user configuration can be set by `.latexcfg` file in project directory:

```
{
"root": "yourfilename.Pnw",
"toolchain": "build.bat %DOC.%EXT",
"latex_ext": [".Pnw", ".pnw", ".texw", ".tex"]
}
```

The current syntax highlighter does not support inline Pweave code in inline math expressions as `$ x= <%= x %> $`. A workaround is to use an alternative markup of the inline math as `\begin{math} x= <%= x %> \end{math}`.

Example of Pweave file opening in the Atom is presented below:

![access_pweave_atom](https://user-images.githubusercontent.com/2492702/127945452-293e29bd-0693-4962-9230-9ef9ec308e48.png)

[[https://github.com/starlinq/images/blob/28d38c9ae929150a1bf102b4d620af20ce728bc4/access_pweave_atom_.png]]



