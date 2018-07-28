set _version to {"1.0.0", "Charles Ross", "18-07-27"}

set _ddr_dir to "/Users/chuck/Projects/chivalry/fm-dev-start/" & "DDR/"
set _quoted to quoted form of _ddr_dir

do shell script "mkdir -p " & _quoted
try
	do shell script "rm " & _quoted & "*"
end try

tell application "System Events"
	launch
	tell process "FileMaker Pro Advanced"
		set frontmost to true
		
		delay 0.25
		tell menu bar item "Tools" of menu bar 1
			click
			click menu item "Database Design Report..." of menu 1
		end tell
		
		delay 0.25
		
		click radio button "XML 2 of 2" of window "Database Design Report"
		if (value of checkbox "Automatically open report when done" of window 1) = 1 then
			click checkbox "Automatically open report when done" of window 1
		end if
		delay 0.25
		
		click button "Create" of window 1
		
		delay 0.25
		keystroke "g" using {command down, shift down}
		
		delay 0.25
		keystroke _ddr_dir
		
		delay 0.25
		keystroke return
		
		delay 0.5
		keystroke return
		
	end tell
end tell

do script "dialog-loop: Test"
