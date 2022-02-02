# birdsong #

## milestones ##
### 1/21: Initial commit ###   
* created repo
* added /sc/[hansm-bird.scd](https://fredrikolofsson.com/f0blog/hansm-bird/) from fredrik olofsson
* set up python 3.10 virtual environment
* installed scikit-image

### 1/28: testing NRT and command line arguments ###
* added /sc/nrtTest.scd   
### 2/2: converting hansm-bird to NRT ###   
* added hansm-bird-nrt.scd
* added nrttest.bat
* added example-birds.txt

## configuration notes ##

_set up venv in vscode:_
`python -m venv .venv`

_to activate venv in vscode:_
command palette (Ctrl+Shift+P): `Python Select Interpreter`

_to fix venv permission issue on windows:_
`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`

_to use requirements.txt:_
`pip install -r requirements.txt`


in /sc try eg: `sclang.exe .\nrtTest.scd testing 5`
be sure sclang.exe is in Path

