-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMIDExhc3RQb3NpdGlvbglJbnN0YW5jZXMNV29ybGRQb3NpdGlvbgVTb2x2ZRRVcGRhdGVUb05leHRQb3NpdGlvbgZDRnJhbWUGbG9va0F0CVZpc3VhbGl6ZQAEBgIAAAAHBAAABQIEBBVNAgFJAAAAACsCBwBNAwHnAQAAABMCAwBNAgLgAgAAADACAUkAAAAATQIBSQAAAABNBQHnAQAAABMEBQBNBATgAgAAAE0FAUkAAAAAJgMEBYICAwADAwEDAgMDAAkEARgAAAABAAAAAAAAAwABAAAAAAAAAAILAAAAAAQCAAAABwQAAAUCBAQGTQMB5wAAAAATAgMATQIC4AEAAACCAgIAAgMCAwMAFQUBGAAAAAAAABYAAAAABQIAAAAHBAAABQIEBAukAgIAAAQAgE0EAecDAAAAEwMEAE0DA+AEAAAATQQBSQUAAACfAgMAggIAAAYDBgMHBAAEAIADAgMDAwEAGQgBGAAAAAAAAAAAAAAAGgAAAAACAAABAgANowAAAP8AAwAAAAAAwAEAADABALQBAAAAwAECADABAHcDAAAAwAEEADABAIIFAAAAggACAAYGAAMEBgEDBQYCAwgDAAECAQABGAAEAAQAAAwAAAQAAAQBAAAAAAOogSkJCKcrUDFYpjPwWC6Y2Jk+fZpFQwg=

-- https://lua.expert/
return {
	Solve = function(p1, p2) --[[ Solve | Line: 9 ]]
		if not p2.LastPosition then
			p2.LastPosition = p2.Instances[1].WorldPosition
		end

		return p2.LastPosition, p2.Instances[1].WorldPosition - p2.LastPosition
	end,
	UpdateToNextPosition = function(p1, p2) --[[ UpdateToNextPosition | Line: 21 ]]
		return p2.Instances[1].WorldPosition
	end,
	Visualize = function(p1, p2) --[[ Visualize | Line: 25 ]]
		return CFrame.lookAt(p2.Instances[1].WorldPosition, p2.LastPosition)
	end
}