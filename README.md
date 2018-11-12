# castor
<p align="center">
    <img src="images/pudding.png" width="256" align="middle">
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
Castor image: https://upload.wikimedia.org/wikipedia/commons/2/20/Kastor_Niobid_krater_Louvre_G341.jpg
Language Icons:
  * Vim: http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team/vim-icon.html
  * Bash: http://www.iconarchive.com/show/enkel-icons-by-froyoshark/iTerm-icon.html
  * Plain Text: http://www.iconarchive.com/show/ios7-style-icons-by-matiasam/Text-icon.html
  * Python: http://www.iconarchive.com/show/papirus-apps-icons-by-papirus-team/python-icon.html
  * JS: http://www.iconarchive.com/show/mnemo-icons-by-hechiceroo/js-icon.html
