# castor
<p align="center">
    <img src="https://github.com/thetomcraig/CASTOR/blob/master/images/pudding.png" width="256" align="middle">
</p>  

Creating new projects shouldn't be boring!  
Castor can create (or `cast`) new projects like a champ.  

## Features
* Castor can create a git-enabled starter project using one of the following schemas (or `molds`):  
  * Python
  * Bash/sh
  * Plain Text
* After making this project locally, Castor can push it to a remote location like GitHub
* For more detail see the [Molds](#molds) section

## Quick Start
* Castor has `molds` for each type of project.  
  * These can be viewed in the `molds` folder
* When you `cast` a new project, Castor will use one of these molds as a base
* Example: Python
  ```
  $ ./castor.sh --cast new_project
  What type of project is this?
  [1] plain_text
  [2] bash
  [3] python
  $ 3
  starting new PYTHON project, 'new_project'
  Casting from mold...
  DONE
  Staging commit...
  DONE
  Creating remote repository...
  $    Enter host password for user 'thetomcraig':
  DONE
  Pushing local repository to remote...
  DONE
  ```

## Commands
* `./castor.sh --cast <name of new project>`
  * This command will create the new project with a name specified

* `./castor.sh --create <name of new project>`
  * Same as `--cast`

* `./castor.sh -c <name of new project>`
  * Same as `--cast`

* `./castor.sh -h`
  * Show help text

## Molds
### Plain Text
* Features
### Bash
* Features
### Python
* Features

### Credits
<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
