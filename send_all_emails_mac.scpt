display dialog "Enter the name of the module" default answer ""
set module to text returned of result
set myName to "Peter" -- TODO: change this to your own
set theSubject to "Intro to Programming " & module & " feedback"
set theBody to "Hi,
Attached is feedback for your " & module & " submission.
Enjoy your week,
" & myName

set mainPath to (the POSIX path of (choose folder with prompt "Choose directory containing submissions"))
set mainPathPOSIX to POSIX file mainPath
tell application "Finder"
	set fl to folders of folder mainPathPOSIX
end tell

repeat with f in fl
	set filename to name of f
	set theRecipient to ((characters 4 thru -1 of filename) as string) & "@student.vu.nl" --trim first 3
	tell application "Mail"
		set theNewMessage to make new outgoing message with properties {subject:theSubject, content:theBody & return & return, visible:true}
		tell theNewMessage
			make new to recipient with properties {address:theRecipient}
			set pdfFile to POSIX file ("" & mainPath & "/" & filename & "/.latex/" & filename & ".pdf") -- TODO: this is the path to the LaTeX PDF - modify it as desired - it's currently set to where my text editor saves LaTeX PDFs by default
			make new attachment with properties {file name:pdfFile}
			set sender to "Peter Atkinson <p.d.atkinson@student.vu.nl>" -- TODO: change this to your own
			--send -- TODO: uncomment this to send the email automatically (not recommended if this is your first time using the script)
		end tell
	end tell
end repeat
