fmgit 1.0.0
===========

fmgit provide the means for submitting a locally served file to a git repository and push the commit to a master server.
Currently only supports macOS and FileMaker Server running on the local machine.

Requirements
------------

- macOS with git installed
- fm-dev-start's custom function library
- BaseElements plugin if you want to generate DDRs during the commit process

Integration Instructions
------------------------

1. Import all of the custom functions from the fm-dev-start file.
2. Copy the `fmgit` script folder to your solution.
3. Edit the `fmgit: Config` script to properly set the following variables:
  - $_repo_dir should be set to the POSIX path of your repository, i.e., "/Users/chuck/Projects/fmgit/"
  - $_fms_username should be set to the admin console username for FileMaker Server
  - $_fms_password should be set to the admin console password for FileMaker Server

Usage
-----

Place a call to `fmgit: Commit Project` or `fmgit: Save DDR and Commit Project` whereever it's convenient for you, perhaps
in a special "Developer" menu.

The first time you call either of these scrips, you may be asked for your account password to give FileMaker access to the
keychain for `git push`. If you enter the password and choose the "Always Allow" button, this should be the only time the
password is requested.

The first time you call `fmgit: Save DDR and Commit Project` you may be asked to give FileMaker Pro Advanced permission to
control the interface within the Accessibility panel of System Preferences. Again, you will only need to do this the first
time.

Note that when you run `fmgit: Save DDR and Commit Project`, you need to wait until it completes. There will be a small
time frame when you are able to work with FileMaker, and if you do this before the DDR generation completes, you may break
the routine. You'll know you can intereact with the app again once you've been presented with the commit message dialog box
and have dismissed it.

To Do
-----

- Add support for files served on a host other than the local machine
- Add support for Windows
- Add support for selecting only the current file during DDR generation

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 18-07-25

[chuck]: mailto:chivalry@mac.com
