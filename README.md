github-installer
===============  
  
**A simple tool for cloning git repos and installing scripts.**

It's an easy way to install my little scripts (repos under the *parhuzamos* user). The corresponding scripts will have commands how to use this tool.

Concept
-------
* Select a target dir (like /opt)
* Clone the repo (which is passed as a parameter) into the selected directory
* Select a directory for symlinks based on *$PATH*
* Search for possible scripts in the install directory
* Place symlinks in the selected directory
* Create an uninstall script which removes to symlinks and the install dir

Todos
-----
See & edit here: https://waffle.io/parhuzamos/github-installer
