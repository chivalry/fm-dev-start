dialog-loop 1.0.0
=================

Displays a dialog in a loop until tests have been passed. Failed tests alter the dialog box informing the user of the
requirements to pass the test.

Requirements
------------

- This file's custom function library

Integration Instructions
------------------------

1. Import all of the custom functions from the this file.
2. Import the `dialog-loop` script folder.

See the "Script Parameters" section of the `conventions.md` file or `Conventions` script for instructions on passing
parameters to public scripts.

Usage
-----

Call `dialog-loop: Begin Loop ( Title ; BaseMsg ; Inputs ; Tests ; Msgs {; Btns ; Labels ; PWStart} )`. See the comments in
that script for the needs of the various parameters.

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 18-07-30

[chuck]: mailto:chivalry@mac.com
