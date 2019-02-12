utilities 1.0.2
===============

The `utilities` module is for general utilities that are useful but not related, and therefore don't easily
fit into other module umbrellas.

Requirements
------------

- fm-dev-start's custom function library

Integration Instructions
------------------------

1. Import all of the custom functions from the fm-dev-start file.
2. Import the `utilities` module folder.

See the comments within the `Script Parameter Passing Readme` for instructions for passing parameters to public
scripts.

Usage
-----

The `utilities` module includes the following scripts:
- `utilities: Script Start:                                      A standard script with actions most other scripts should
                                                                 take, such as hiding the tool bar except for developers.
- `utilities: Go to Field by Name ( Field {; NewWindow} )`:      Given a fully-qualified field name, exits in a
                                                                 state where the named field is the active field.
- `utilities: Go to Record ( Table ; Criteria {; NewWindow } )`: Given a table name and let-notation specified
                                                                 criteria, exits in a state where that record is
                                                                 the current record.
- `utilities: Export Container to Temp ( Field ; Criteria )`:    Given a fully-qualified field name and let-notation
                                                                 specified criteria, exports the container field's
                                                                 contents to the temporary folder.
- `utilities: Toggle Field Value ( FieldName ; Value ):          Toggles the named field with the value, clearing it if it
                                                                 already has that value.
- `utilities: Clear All Global Fields`:                          Useful in the `OnFirstWindowOpen` script to remove any
                                                                 data from global fields, possibly left over from when the
                                                                 file was locally opened.

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 17-11-08
1.0.1 - [Charles Ross][chuck] - 18-07-30 - Removed `utilities: Clear Dialog Field Reps` as unnecessary with FM17.
1.0.2 - [Charles Ross][chuck] - 19-01-29 - Edited readme to reflect new file name.

[chuck]: mailto:chivalry@mac.com
