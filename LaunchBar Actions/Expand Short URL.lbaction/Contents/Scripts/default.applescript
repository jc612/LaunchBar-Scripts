(*
Expand Short URL's
This LaunchBar Action returns a list of individual expansions
of a given short URL, e.g. http://t.co/7QpX0saACo

Created by Andreas "Zettt" Zeitler on 2014-07-04
Mac OS X Screencasts, zCasting 3000
*)
-- Changes
-- 1.0: Initial version.
-- 1.1: 
--    - Fancy new icon
--    - Returning |url| now instead of an action argument. This makes several things integrate better with LaunchBar, e.g. ↩, ⌘C
--    - Error handling
--    - Documentation
-- 1.2: 
--    - German localization
--    - Code signed ❤️
-- 1.3: 
--    - This is now a .applescript (no code changes)
-- 1.3.1: Added LBAcceptedArgumentTypes to Info.plist


-- By default check the clipboard for a URL and expand it
on run
	
	if (the clipboard as string) begins with "http" or (the clipboard as string) begins with "https" then
		set expandedURLs to do shell script "curl -sIL `pbpaste` | grep ^[lL]ocation | cut -c 11-"
	else
		return "No URL on clipboard."
	end if
	-- for testing purposes only:
	-- set expandedURLs to do shell script "curl -sIL 'http://t.co/7QpX0saACo' | grep ^[lL]ocation | cut -c 11-"
	-- log expandedURLs
	
	return assembleLaunchBarResult(expandedURLs)
end run

-- Alternatively this action can have a URL passed to it
on handle_string(_shortURL)
	
	if _shortURL begins with "http" or _shortURL begins with "https" then
		set expandedURLs to do shell script "curl -sIL " & _shortURL & " | grep ^[lL]ocation | cut -c 11-"
	else
		return "Please provide a valid URL."
	end if
	
	return assembleLaunchBarResult(expandedURLs)
end handle_string

-- this creates the list of expanded urls for LaunchBar
on assembleLaunchBarResult(_listOfURLs)
	set returnValue to {}
	
	repeat with i from 1 to (the count of paragraphs of _listOfURLs) in _listOfURLs
		--log paragraph i of expandedURLs
		set _thisURL to (paragraph i of _listOfURLs) as string
		--set returnValue to returnValue & {{title:_thisURL, URL:_thisURL, action:"copyURL", actionArgument:((paragraph i of _listOfURLs) as string)}}
		set returnValue to returnValue & [{title:_thisURL, |url|:_thisURL}]
	end repeat
	
	return returnValue
end assembleLaunchBarResult

-- This is not needed anymore, but I wrote it and I'm sentimental
on copyURL(_urlToCopy)
	set the clipboard to _urlToCopy
	tell application "LaunchBar" to hide
end copyURL
