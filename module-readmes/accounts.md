account 1.0.1
=============

Allows centralized account management so that accounts can be created, deleted and have passwords changed across multiple
files.

Requirements
------------

- chiv-lib's custom function library
- chiv-lib's `utilities` module
- A table to keep records matching accounts with a field tracking if the account is active

Integration Instructions
------------------------

1.  Import all of the custom functions from the chiv-lib file.
2.  Follow the instructions for integrating the `utilities` module, making sure to connect that module's
    `~dialog_field_name`.
3.  Import the `account` module script folder into your master file.
4.  Edit the script `account: Settings` and record the following settings:
    - `$_is_active_field` should store the fully-qualified field name of a number field to store whether a user is
      active or not, i.e., `GetFieldName ( USR::is_active )`.
    - `$_can_change_passwords` should store a boolean value that when true allows a user to change other users'
      passwords, for example, `dev.IsDeveloper or ( Get ( AccountExtendedPrivileges ) = "Administrator" )`.
5.  Edit line 10 of the `account: Password Solicitation Dialog ( Title ; Msg )` dialog to use the first two
    repetitions of the dialog field configured within the `utilities` module for the two input fields.
6.  For each external file in your solution:
    1. Import all of the custom functions from the chiv-lib file.
    2. Import the `account: External` folder of scripts.
    3. Edit `account ext: Create ( Name ; PrivSet ; Password )` so that each available privilege set has an `If`
       block with an `Add Account` script step duplicated from those already present with the hard-coded
       privilege set correctly specified.
7.  In the master file, edit `account: Create Account ( Name ; PrivSet ; Password )` by duplicating line 22 for each
    external file and point each `Perform Script` line to each external file's `account ext: Create ( Name ; PrivSet ;
    Password )`.
8.  Give `account: Create Account ( Name ; PrivSet ; Password )` a set if `If`/`Else If` blocks for each privilege set
    as you did in the nexternal files.
9.  Edit `account: Delete Account ( Name )` to call each external file's `account ext: Delete ( Name )` script.
10. Edit `account: Set Password ( Name ; Password )` to call each external file's `account ext: Set Password ( Name ;
    Password)` script.
   

See the comments within the `Script Parameter Passing Readme` for instructions for passing parameters to public
scripts.

Usage
-----

Each script in the API has an `Auth` parameter. If the current user is authorized to perform the actions in the script,
this should be passed a value of `True`. Anything other thatn `True` should be an error messages that will be displayed to
the user.

- `account: Create ( Auth ; Name ; PrivSet ): Pass the `Auth` value as described above, an account name in `Name` and the
  privilege set name in `PrivSet` to create an account.
- `account: Delete ( Auth ; Name ): Pass `Auth` as described above and an account name to delete an account. There is no
  support for FileMaker's `Deactivate Account`, use this instead.
- `account: Set Password ( Auth ; Name )`: Pass `Auth as descrsibed above and a name of an account to change the
  password of.

Version History
---------------

1.0.0 - [Charles Ross][chuck] - 18-05-14
1.0.1 - [Charles Ross][chuck] - 18-05-15 - Update to take advantage of FileMaker 17's input field to variable feature
1.0.2 - [Charles Ross][chuck] - 18-07-30 - Update to take advantage of dialog-loop module.

[chuck]: mailto:chivalry@mac.com
