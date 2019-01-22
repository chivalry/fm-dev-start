Tables
======

Each table is created by duplicating the `_TEMPLATE` table, ensuring each table has the right default fields.  The `_TEMPLATE` table has one table occurrence, `-`, which is useful for divider layout context.

Tables are organized into categories, which are fieldless tables with no table occurrence. Three exist by default, `_____ MAIN TABLES _____...`, `_____ JOIN TABLES _____...`, and `_____ UTILITY TABLES _____...`. The trailing underscores continue to the maximum name length for tables, 100 characters.

Table names all capitals and are generally abbreviations of the entities they store, so a table storing persons would probably be called `PRSN`, one storing locations, `LOC`. Obvious abbreviations are to simply remove the vowels.

Join tables are generally named with the two tables names concatenated unless there's an obvious name for the entity. So, the join table between `INITV` and `SSNS` is `INITVSSNS`, which the self-join that tracks connections between people is `CNCTNS`.

Two utility tables exist, `SEL`, and `DEV`. `SEL` is a single-record table used as the single table for the Selector/Connector model. `DEV` is a single-record table that stores non-Selector/Connector global fields.

Table Occurrences
=================

Every (data) table gets at least three table occurrences:

- The first one created is always used as the TO to be used for layout context and is always named exactly the same as the base table.

- Each table gets a field in `SEL` named `<<table_name>>_ID` and a relationship to this TO uses this field and the table's `id` field as the match field. The TO is named `sel_<<table_name>>`.

- `SEL` has a `CREATE_UUID` field. Each table has a TO named `<<table_name>>~create` with a relationship to `SEL` using `CREATE_UUID` and the table's `uuid` field as the match field with the relationship allowing the creation of related records.

Relationships can fall off of the primary TOs or the `sel_*` TOs. TO names are always named with the name of the parent TO in lower case letters, the appending of an underscore, and the name of the base table in capital letters. If this scheme results in identical names, a tilde is added followed by a differentiating label. Some examples:

- `PRSN`
- `prsn_INITV`
- `prsn_initv_NOTE`
- `prsn_INITV~blessed`
- `sel_MTGS`
- `sel_mtgs_UNDSTG`
- `sel_mtgs_UNDSTG~existing`

Fields
======

Fields are named in lower-case snake case (`field_name`). Global fields (or fields that otherwise have the same value for every record) are named in upper-case snake case (`GLOBAL_FIELD`).

Like divider tables, divider fields include names that max out the field name length, 100 characters. Five divider fields exist by default:

- `_____ ID FIELDS _____...`: Primary and foreign keys go here. By default it has the following primary keys:
  - `id`: Text field, auto-enter serial number beginning with 1
  - `uuid`: Text field, auto-enter `Get ( UUIDNumber )`
  - `fm_id`: Calculation with text result of `Get ( RecordID )`

- `_____ TABLE DATA _____...`: Additional fields unique to the table will generally go here. Initially this section is empty.

- `_____ RELATIONSHIP KEYS _____...`: For additional match fields other than keys. For example, if a value list is needed that shows only records that have a status of "Complete", a global calculation could be placed here with that string as the result and be used as a match field to the status field. The default fields here are:
  - `ONE`: A calculation field set to `1` used to create relationships to boolean fields.
  - `TABLE_NAME`: A text field that auto-enters a calculation of `dev.GetTableName ( Self )`, which returns the table's name. Useful when creating relationships to tables that can be related to many other tables, such as a documents or notes table.

- `_____ HOUSEKEEPING FIELDS _____...`: Stores the standard fields to track who created and modified a record and when it happened. The default fields include:
  - `created_by`: Auto-enter creation account name.
  - `created_timestamp`: Auto-enter the creation timestamp.
  - `created_date`: Calculation with result of `GetAsDate ( created_timestamp )`.
  - `created_time`: Calculation with result of `GetAsTime ( created_timestamp )`.
  - `modified_by`: Auto-enter calculation, see details below.
  - `modified_timestamp`: Auto-enter calculation, see details below.
  - `modified_date`: Calculation with result of `GetAsDate ( modified_timestamp )`.
  - `modified_time`: Calculation with result of `GetAsTime ( modified_timestamp )`.
  - `housekeeping_trigger`: auto-enter modification timestamp, see details below.
  - `housekeeping_display`: A calculation that returns `dev.Housekeeping`, which is used to provide a standard format for layout feedback of a records creation and modification details.

Housekeeping Fields
-------------------

Because it's sometimes desirable to be able to modify with a script without updating the modification details, the modification housekeeping fields auto-enter the following calculations:

    modified_by =
    Let (
      _trigger = housekeeping_trigger ;

      Case (
        $$_SUSPEND_HOUSEKEEPING_UPDATES ; Self
                                        ; Get ( AccountName )
      )
    )

    modified_timestamp =
    Let (
      _trigger = housekeeping_trigger ;

      Case (
        $$_SUSPEND_HOUSEKEEPING_UPDATES ; Self
                                        ; Get ( CurrentTimestamp )
      )
    )

A script can now set the `$$_SUSPEND_HOUSEKEEPING_UPDATES` global field and make changes to records without updating the fields' contents.

Variables
=========

- Global Variables: upper-case snake case with prepended underscore (`$$_GLOBAL_VARIABLE`).
- Local Variables: lower-case snake case with prepended underscore (`$_local_variable`).
- Let Variables: lower-case snake case with prepended underscore (`_let_variable`).
- Custom Function Parameters: same as Let variables (`_parameter_name`).
- Script Parameters: camel case (`$ScriptParameter`).
- Script Results: lower-case snake case with prepended tilde (`$~script_result`).
- Global Module Variables: same as for global variables, but with the module name prepended to avoid name collisions (`$$_MODULE_NAME_GLOBAL_VARIABLE`).

Scripts
=======

Script Parameters
-----------------

Script parameters are **always** passed using let notation, even if only one parameter is needed. Custom functions exist to make this easy. `script.Param` takes the name of a parameter and a value and formats it as let notation. Scripts are named such that required parameters appear within parentheses at the end of the script name and optional parameters appear within brackets, i.e., `Script Name ( Requied1 ; Required2 [; Optional ] )`. Multiple parameters are set by concatenated with the `&` operator. The parameters to a call to the above script might look like this:

    script.Param ( "Required1" ; $_value_1 ) &
    script.Param ( "Required2" ; $_value_2 ) &
    script.Param ( "Optional" ; $_optional )

Within scripts that accept parameters, one of the first script steps will be `If [ script.AssignParams ]`. `script.AssignParams` compares the received parameters to those required by the script name and returns `True` only if all of them are present. All parameters received are assigned to variables with their name. With the above example, if all parameters were provided, the execution of `script.AssignParams` would create three variables: `$Required1`, `$Required2`, and `$Optional`.

Note that `script.Param` is a wrapper for `let.Set`. At some point I might change from using let notation to JSON, but haven't seen a need or advantage to doing so yet.

Script Results
--------------

Script results are **always** passed using let notion. In this case, `let.Set` is generally used, but `script.Param` could be used as well, as it's a wrapper for `let.Set`. Names passed to `let.Set` should include a prepended tilde so the calling script can see that the variables being set are from a script result, i.e., `let.Set ( "~script_result" ; $_value )`. Multiple `let.Set` calls are simply concatenated with the `&` operator.

Script Organization
-------------------

Scripts are organized into the following folders:

### Developer

The "Developer" folder stores two template scripts: `Script Template` and `PSoS Template`, which should be duplicated when creating new client-side and server-side scripts respectively.

#### `Script Template`

`Script Template` has the following lines.

    1 # Purpose:    none
        Parameters: none
        Return:     none
        Version:    1.0.0 - Charles Ross - 17-11-08
        Notes:      none
    2
    3 Allow User Abort [ Off ]
    4 If [ script.AssignParams ]
    5
    6 End If
    7
    8 Exit Script [ Text Result: ]

Line 3 can be deleted if this is always a subscript called by another script. Lines 4-6 can be deleted if the script accepts no parameters. The comment should be updated as appropriate, deleting any lines that aren't relevant.

The version should be updated whenever an edit is made after the first version of the script. A description of the edit should appear after the date stamp (which is in YY-MM-DD format). Whether an edit warrants a revision, minor, or major increment of the version is up to the developer. After a few edits, the script header might look like this.

    Purpose:    A description of the script's purpose.
    Version:    1.0.0 - Charles Ross - 17-11-08
                1.0.1 - Charles Ross - 17-12-20 - Bug fix
                1.1.0 - Charles Ross - 18-02-02 - Minor version description
                2.0.0 - Charles Ross - 18-05-20 - Complete rewrite

#### `PSoS Template`

`PSoS Template` has the following lines.

    1  # Purpose:    none
         Parameters: none
         Return:     none
         Version:    1.0.0 - Charles Ross - 17-07-03
         Notes:      none
    2 
    3  Allow User Abort [ Off ]
    4  If [ psos.ShouldPerformOnServer ] 
    5      Set Error Capture [ On ]
    6      Perform Script on Server [ Wait for completion: On ; “PSoS Template” ; Parameter: Get ( ScriptParameter ) ]
    7      Set Variable [ $_result ; Value: Get ( ScriptResult ) ] 
    8      
    9      If [ Get ( LastError ) = err.HostExceedsCapacity ] 
    10         
    11         If [ dev.IsDeveloper ] 
    12             Show Custom Dialog [ "Host Exceeds Capacity" ; "A \"Host Exceeds Capacity\" error was received while attempting PSoS." ] 
    13         End If
    14         
    15         Set Variable [ $_ ; Value: psos.TurnOverrideOn ] 
    16         Perform Script [ “PSoS Template” ; Parameter: Get ( ScriptParameter ) ]
    17         Set Variable [ $_result ; Value: Get ( ScriptResult ) ] 
    18         Set Variable [ $_ ; Value: psos.TurnOverrideOff ] 
    19         
    20     End If
    21     
    22 Else
    23     
    24     If [ script.AssignParams ] 
    25        
    26         Set Variable [ $_result ] 
    27     End If
    28     
    29 End If
    30 
    31 Exit Script [ Text Result: $_result ] 

The header comment should be edited as it should in the client-side `Script Template`. Also, as with that template, line 3 can be deleted if this is always a subscript and lines 24 and 27 can be deleted if no parameters are expected. If no script result is needed to be passed to the calling script, lines 7, 17, and 26 can be deleted and the result removed from line 31.

The purpose of this script's structure is to allow a single script to be self-contained and run on the server if possible, but run locally if necessary.

### Triggers

All script triggers should call these scripts. There's one script for each available trigger and (except for window opening and closing scripts), each can accept an optional `Sender` parameter. Since each script documents what it returns and ensures a nice default is returned when a trigger expects a return value, this makes for an easy reference to script trigger documentation as well as a central place for the trigger scripts to exist.

Unused scripts are named simply after the trigger they are for. Once a script trigger is actually assigned to a script, that script's name is prepended with an underscore to indicate it's actually being used.

Subfolders exist here for the `OnFirstsWindowOpen` and `OnLastWindowClose` scripts as those tend to be longer and are more likely to make use of subscripts.

### Callbacks

Some modules offer additional behaviors to be executed at certain points in their own execution. When taken advantage of, this additional behavior is generally short, but occasionally needs to be quite long. When that becomes the case, a subscript is created that is named after the event that's happening and the behavior that's being augmented, such as `New Initiative Precommit Callback`.

### Modules

Modules are sets of scripts that are intended to be, as much as possible, copied and pasted into solutions, but in practise, finished modules are simply included in new systems. With modules good modules in place, I've found that the need for other scripts is greatly reduced. I would estimate that 80% of the code that gets executed in my current systems is module code.

Modules always include a readme script (in Markdown format) and three folders, one for public scripts, one for tests and one for private scripts. Scripts outside a module should only ever call the public scripts. An additional configuration folder is optional. Finally the `account` module includes an external folder for scripts that only need to be included in other files. The subfolders within a module folder are named as follows:

- `<<module_name>>: README`
- `<<module_name>>: Config`
- `<<module_name>>: Public`
- `<<module_name>>: Tests`
- `<<module_name>>: Private`

Module scripts are named first with the module name followed by the script itself, as in `account: Create Account ( Name ; PrivSet ; Password )`. Private scripts are differentiated by placing the word `priv` between the module name and script name, i.e., `account priv: Create ( Auth ; Name ; PrivSet )`.

Currently, the following modules are finished.

- `account`: Provides scripts for creating, deleting, and changing passwords for accounts across files.
- `capture-set`: Captures the primary keys of the records in the current found set. Obsolete, given the new master/detail view feature available in FileMaker 17.
- `issues`: Provides scripts for users to submit bug reports and feature requests.
- `popin`: Provides scripts for using standard layouts as dialog boxes for creating and editing records.
- `primary-key`: Provides a single place for the primary key standard to be reported to other modules.
- `utilities`: Here are useful scripts that don't easily fit in any other module, such as `utilities: Export Container to Temp ( Field ; Criteria )`.
- `window`: Provide scripts for creating properly placed windows, including utility windows that appear on screen for developers and off screen for users.

### Navigation

When a script needs to move from one layout to another, or open a non-popin window, this is considered a navigation, and the script is placed here.

### Operations

Operations edit a record somehow, or perhaps create or delete a record. Such scripts are stored here.

### Reports

Any printed report scripts are stored here.

### Sorting

Scripts that perform sorting routines, such as might exist for buttons atop a list view or portal, would go here.

### Searching

Any script whose sole purpose is to find records will go here. Other scripts might have searching, but this folder is for scripts where that's the only purpose.

### Menus

Any scripts that are executed by menu items go here and are named after the menu item's path, such as `Requests » Show All Records` and `Developer » Open Temp Folder`. 

Custom Functions
================

Like tables and fields, custom functions are divided into groups. Here, groups are of the form `<<group_name>>_____ Group Description _____...`. Functions themselves are named `<<group_name>>.FunctionName`, using camel case for the function name. Group names are generally pretty short, but should be descriptive enough to be unambiguous.

Every solution I work with, whether I created it or am coming to an existing system, gets my custom function library imported into it. I'm a larger fan of custom functions than is generally found in the FileMaker community. In addition to using them for their intended purpose, I also use them to increase readability and build documentation into calculations. Often functions perform both of these tasks.

An example of this is the `modifier` set of custom functions. Without these functions, checking for a particular modifier key being held down would look something like this: `If [ Get ( ActiveModifierKeys ) = 2 ]`. Perhaps the next developer reading this will remember what `2` corresponds to, or they can take the time to look it up. The `modifier` set allows this calculation to become `Get ( ActiveModifierKeys ) = modifier.Shift`.

It also includes an additional function, `modifier.KeyActive`, which will check if the key is held down even in combination with other keys, in which case the calculation becomes `modifier.KeyActive ( modifier.Shift )`.

Many of the groups in my custom function library are dedicated to this, including `err` for error numbers, `mode` for window modes, `platform` for architecture and operating system platforms, `sort` for constants used with `SortValues`, and `system` for commonly referenced system settings such as values returned by `Get ( RecordState )`.

A custom function group that is initially empty in new systems is `app_____ Application Functions _____...`, which is where application specific custom functions are stored.

### Custom Function Templates

Two custom function templates are available from which all new custom functions begin. `__function_template` is for standard or simple recursive custom functions, while `__recursive_template` is for complex recursive functions.

#### `__function_template`

Here's the contents of `__function_template`:

    // Template
    // Purpose:		description
    // Parameters:		_param:	description
    // Requirements: 	requirements
    // Version:		1.0 - Charles Ross - 17-03-08
    // Notes:			Notes
    // Todo:			To dos
    // Example:		sample = result

    Let (
      [
        _ = ""
      ] ;

      ""
    )

The alignment above is off because we don't yet have the new calculation dialog box available for custom functions, so option-tab is used to align the text. Most of this is similar to the comment header of scripts.

The template provides the name of the function and the parameters and is useful when storing custom functions in text files. An example would be `script.Param`, which has a template of `script.Param ( _name ; _value )`.

The notes and todo portions are probably obvious. Example should provide a valid calculation using the custom that returns `True`. For, um, example, the example for `math.FormatCurrency` is `math.FormatCurrency ( 12345.67 ) = "$12,345.67"`.

#### `__recursive_template`

`__recursive_template` is for complicated recursive functions where the execution can be broken up into three stages: setup, recursion, and cleanup. An example of this is `schema.DataFieldNames`, which, given a table name, returns the name of data fields (i.e., not calculations, summary or global fields).

Layouts
=======

All files get the following layout folders:

- Developer
- Desktop
- iPad
- iPhone
- Web
- Print
- Dialogs

Every table gets a layout named after it in the "Developer" folder. These layouts are given the "Chivalry Dark" theme. This makes it easy to specify a developer layout in a script by using `dev.GetTableName`, which, given a field, will return the name of the table. For example, `dev.GetTableName ( PRSN::id ) = "PRSN"`.

All layouts have a context into a primary table occurrence. Every divider layout has a contents of the `-` table occurrence.

Objects
=======

Objects are given names at least when they need one for use with a `Go to Object` script step. Generally (my convention on this is still evolving), the name takes the form of `<<object_type>>.<<object_name>>_<<location>>`. The `<<location>>` is used when its absence would result in two objects with identical names, such as `button.new_initiative~learn`, `button.new_initiative~session`, and `button.new_initiative~initiatives`.

Objects are also given names if they send script triggers, in which case this is the name sent to the script as the `Sender` parameter.

Styles
======

Another evolving convention. I'm experimenting with immediately duplicating standard themes, such as "Enlightened" and "Enlightened Touch", and calling the duplicated themes "Chivalry Enlightened" and "Chivalry Enlightened Touch". Then if I edit the attributes of an object, I save that as a new style and name the style as what it's used for, such as "Chivalry Icon Popover". My goal with this is to never have objects that differ from their given style. I haven't yet accomplished this.

Menus
=====

Another evolving convention. I've started using a single menu set but using the ability to hide menus and menu items to hide "dangerous" menu items from users. I've also included a "Developer" menu that includes "Manage," "Scripts," and "Window" menus within it, as well as a few scripts useful for developers.
