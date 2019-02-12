execute 1.0.0
=============

`execute` is a module for executing shell commands from FileMaker, with the option to export a script file first.

Requirements
------------

- fm-dev-start's custom function library
- fm-dev-start's `utility` module
- macOS

Integration Instructions
------------------------

1. Import all of the custom functions from the this file.
2. If you'd like to take advantage of exporting a file before executing a script, add the `EXE` table to your file or create one with fields to store the file, the optional command, and the filename.
3. Import the `execute` script folder of scripts.
4. If you didn't copy and paste the `EXE` table, configure the table reference by editing `execute: Settings`.

See the comments within the `Script Parameter Passing Readme` for instructions for passing parameters to public
scripts.

Usage
-----

To simply execute a shell command, call `execute: Do Shell Script ( Cmd )`, passing the command to execute as the parameter.

You can also store a script file in the `EXE` table, store a command in the record with the script file, and call `execute: Execute Script ( Filename {; Cmd } )`. An example of a parameter sent to this script might be:

    script.Param ( "Filename" ; "script.py" ) &
    script.Param ( "Cmd"      ; "python3 script.py" )

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 17-11-25

[chuck]: mailto:chivalry@mac.com
