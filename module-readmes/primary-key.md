primary-key 1.0.0
=================

The primary-key module provides a single place for other modules that need to know the name of primary key fields
to go so that developers don't have to include primary key names in every module. This module also confirms that
the primary key name given is a valid field name in a data table. "Valid primary key name" means there's at least
one table with multiple records that has that field.

Requirements
------------

- fm-dev-start's custom function library

Integration Instructions
------------------------

1. Import all of the custom functions from the fm-dev-start file.
2. Import the `primary-key` script folder and all of its sub-folders and scripts into your solution.
3. Edit line 3 of the `primary-key config: Primary Key Name` script so that `$_pk_name` is set to the name of
   your solution's primary key fields.

Usage
-----

When a module needs to know (and verify) the primary key used in the system, call `primary-key: Primary Key Name`
and use the results returned. Script results are in the form of let-notation with a single key of `~pk_name`. If the
configured primary key isn't valid, execution will halt with an error message.

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 17-11-08

[chuck]: mailto:chivalry@mac.com
