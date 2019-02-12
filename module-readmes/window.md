window 1.0.0
============

The window module provides a scripts to create generic windows for both the users and developers.

Requirements
------------

- fm-dev-start's custom function library

Integration Instructions
------------------------

1. Import all of the custom functions from the fm-dev-start file.
2. Import the `window` script folder and all of its sub-folders and scripts into your solution.

See the comments within the `Script Parameter Passing Readme` for instructions for passing parameters to public
scripts.

Usage
-----

When a new window is needed, call the `window: New ( Layout ; Title {; Style ; Coords ; Size } )` script. See the
header comments for this script for details about the available parameters.

If you need a window for context control, and therefore want it created offscreen for end-users but onscreen for
developers, call the `window: New Utility ( Layout {; WindowID } )` script. This script will return the name of
the window so that the calling script can close it.

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 17-11-08

[chuck]: mailto:chivalry@mac.com
