# castor
<p align="center">
    <img src="https://github.com/thetomcraig/CASTOR/blob/master/images/pudding.png" width="256" align="middle">
</p>  

Creating new projects shouldn't be boring!  
Castor can create (or `cast`) new projects like a champ.  

## Features
Castor performs the following steps:  
  * Creates a new folder with the project name specified
  * `Casts` the new project using one of the available `molds`
    * Moves the default files into the new projects folder
    * Commits them with git
    * Pushes to your GitHub account; creating the remote repo

Curently the following molds exist, With sensible defaults:
  * Python
    * requirements.txt
  * Bash/sh
    * Helper Functions
  * Vimscript
    * Helper Functions
  * Plain Text

Each new project casted will also contain:
  * README.md
  * .gitignore
  * .ackrc
  * .agignore
  * .editorconfig

## Quick Start
Castor has `molds` for each type of project.  
Castor with `cast` a new project using the mold you specify.  
For example, making a new python project:  
```
$ ./castor --cast test_project
What type of project is this?
  [1] Python
  [2] Bash
  [3] Plain Text (Default)
$ 1
Casting from mold...
Casted
Pushing cast...
Enter host password for user 'thetomcraig':$
.
.
.
Cast pushed
Opening remote...
```

## Usage


### Credits
<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
