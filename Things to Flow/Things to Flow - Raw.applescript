-- Things to Flow
-- Jesse Williams (github.com/Jessenw)

-- This script lets the user select a todo from the 'Today' list
-- applies a tag to it, then starts a flow with the todo's name.

-- Main script
on run
	set tagName to "Current flow"
	set listName to "Today"
	
	set todos to getTodos(listName)
	
	-- Display a dialog for the user to select a todo
	set selectedTodo to choose from list todos with prompt "Select a todo" without multiple selections allowed and empty selection allowed
	
	if selectedTodo is not false then
		set todoTitle to applyTag(selectedTodo, tagName, listName)
		setFlowTitleAndStart(todoTitle)
	end if
end run

-- Get the list of todos from listName
on getTodos(listName)
	tell application "Things3"
		set todos to name of to dos of list listName
	end tell
	return todos
end getTodos

-- Apply tagName to the selected todo
on applyTag(selectedTodo, tagName, listName)
	tell application "Things3"
		-- Check if tagName tag exists, if not, create it
		if (count of (tags whose name is tagName)) is 0 then
			make new tag with properties {name:tagName}
		end if
		
		-- Remove tagName from all todos that have it
		tell application "Things3"
			set todosWithNowTag to to dos whose tag names contains tagName
			repeat with todo in todosWithNowTag
				set tagList to tags of todo
				set newTagList to {}
				repeat with t in tagList
					if name of t is not tagName then
						set end of newTagList to t
					end if
				end repeat
				set tag names of todo to my convertListToString(newTagList, ", ")
			end repeat
		end tell
		
		-- Apply tagName to the selected todo
		set selectedTodo to first to do of list listName whose name is selectedTodo
		set tag names of selectedTodo to (tag names of selectedTodo) & {tagName}
		
		-- Get the title of the selected todo
		set todoTitle to name of selectedTodo
	end tell
	return todoTitle
end applyTag

-- Set the title of the current flow and start the flow
on setFlowTitleAndStart(todoTitle)
	tell application "Flow"
		setTitle to todoTitle
		start
	end tell
end setFlowTitleAndStart

-- Convert list to a comma-separated string
on convertListToString(theList, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theString to theList as string
	set AppleScript's text item delimiters to ""
	return theString
end convertListToString