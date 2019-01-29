Security Design
---------------

This document is intended to outline the security used by this file. Generally, FileMaker's built-in security will be used for authentication, but scripts and fields will provide additional flexibility.

Goals
-----

- Use FileMaker's built-in security (accounts, privilege sets, and extended privileges) as much as possible.
- Provide end users the ability, with adequate privileges, to create accounts, delete accounts, and change privilege sets and passwords.
- Provide the ability for the master file to perform these same actions in external files.
- Provide the ability for the master file to push existing accounts to a new external file.

Password Storage
----------------

The ability for the master file to push existing accounts to an external file requires the storing within the database of the password. To offset this security risk, the password field will be encrypted with a key stored in a custom function. The custom function will be available only to full access accounts and only run within scripts that have the full access setting turned on.
