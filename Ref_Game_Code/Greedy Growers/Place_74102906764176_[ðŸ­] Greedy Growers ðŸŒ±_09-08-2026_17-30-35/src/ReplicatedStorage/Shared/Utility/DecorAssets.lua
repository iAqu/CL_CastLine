-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLBkFzc2V0cw5GaW5kRmlyc3RDaGlsZAZHcmVlZHkFRGVjb3IJZ2V0Rm9sZGVyBU1vZGVsA0lzQQ9yZXNvbHZlVGVtcGxhdGUEZ2FtZRFSZXBsaWNhdGVkU3RvcmFnZQpHZXRTZXJ2aWNlAAMFAAEAAAAS+wAAAG8CAAC8AAADAQAAAJ8AAwJSAQAADgEEAG8DAgC8AQADAQAAAJ8BAwJSAgEADgIEAG8EAwC8AgEDAQAAAJ8CAwKCAgIABAMBAwIDAwMEAAgFARgAAAAAAAEAAAAAAAEAAAAAAAAJAAAAAAkCAQAABwQAAAUCg4Mk+wIAAE0CAnUAAAAAnwIBAg4CAQArAQIAxgMAAIIDAgBSAwAADgMEAFIFAAC8AwIDAQAAAJ8DAwJSBAMADgQEAFIGAQC8BAMDAQAAAJ8EAwIrBAUAUgcBALwFAgMBAAAAnwUDAlIEBQAOBAcAbwgCALwGBP4DAAAAnwYDAg4GAgBSBQQAKwUBAMYFAACCBQIABAMFAwIDBgMHABAIARgAAAAAAQAAAAEAAAAAAAEAAAAAAAEAAAAAAAEAAAAAAAAAAAARAAAAAAMAAAECABKjAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMC/wECAAAAAADAAgQAEgAAADACAXUFAAAAwAIGABIAAQAwAgFsBwAAAIIBAgAIAwkEAAAAQAMKAwsGAAMFBgEDCAIAAQEAARgAAwAAAAAAAgACAAAACAAAAAkBAAAAAAJ4qw7VS9NpTVYRlO8Gdtq3CLMZoUpvZNQ=

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {
	getFolder = function() --[[ getFolder | Line: 8 | Upvalues: ReplicatedStorage (copy) ]]
		local Assets = ReplicatedStorage:FindFirstChild("Assets")
		local v1 = if Assets then Assets:FindFirstChild("Greedy") else Assets

		return if v1 then v1:FindFirstChild("Decor") else v1
	end
}

function t.resolveTemplate(p1, p2) --[[ resolveTemplate | Line: 16 | Upvalues: t (copy) ]]
	local v1 = t.getFolder()

	if not (v1 and p2) then
		return nil
	end

	local v2 = if p1 then v1:FindFirstChild(p1) else p1
	local v3 = if v2 then v2:FindFirstChild(p2) else v2

	if not v3 then
		v3 = v1:FindFirstChild(p2)
	end

	return if v3 and (v3:IsA("Model") and v3) then v3 else nil
end

return t