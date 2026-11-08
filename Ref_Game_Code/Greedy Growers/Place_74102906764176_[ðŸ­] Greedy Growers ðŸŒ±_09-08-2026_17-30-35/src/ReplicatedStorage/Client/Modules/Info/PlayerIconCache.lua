-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMNFUdldFVzZXJUaHVtYm5haWxBc3luYwAFcGNhbGwJRmV0Y2hJY29uCHRvbnVtYmVyGkdldFVzZXJJbmZvc0J5VXNlcklkc0FzeW5jC0Rpc3BsYXlOYW1lCHRvc3RyaW5nEEZldGNoRGlzcGxheU5hbWUEZ2FtZQdQbGF5ZXJzCkdldFNlcnZpY2ULVXNlclNlcnZpY2UABQcABQAAAA/7AgAA+wMBAIcBAgP7AgIAhwABAvsBAwD7AgQA+wQBAPsFAgD7BgMAvAICQwAAAACfAgUCagIAAYIAAQABAwEAGwABGAAAAAAAAAEAAAAAAAD/AhwAAAAACQQCAAAJBgAABQQEAg8PMfsFAACHBAUBKwQEAPsEAAD/BQAAAAAAAGoFBAH7BgAAhwUGAYcEBQIrBAUA+wUAAIcEBQH/BQAAAAAAAGoFBAL7BwAAhwYHAYcFBgKHBAUDKwQXAKkEAABvBQAAjAYAACsEEwCkBwIAAAAQQNkIAAASAgAAEgABABIAAgASAAMAEgIBAJ8HAgNSBAcAUgUIACsEAQCVBgYDjAcDAGAHAwAGAAAAbwcAAIIHAgBIAOz/+wcAAIcGBwGHBQYChwQFA4IEAgAEAwIDAwQAABBAAgAAAAAAAPA/AQAMBAEYAAAAAQAAAAMAAAABAAAAAAMAAAAAAQEBAQEAAAAAAAAAAAAABQIDAAABAPQSAAAAAA4AAAAACAADAAAAFPsAAAD7AQEA+wMCAP8FAAABAAAA+wcBALs+BwKkBgEAAAAAQJ8GAgLFBQYCAQAAALwDA+ECAAAAnwMDAhMCAwBNAgJXAwAAAGoCAAGCAAEABAMFBAAAAEADBgMHADcAARgAAAAAAAAAAAAAAAAAAAAAAAAAATgAAAAABwICAAAHBAAABQIEAh/7AwAAhwIDASsCGQCpAgAAbwMAAIwEAAArAhUApAUCAAAAEEDZBgAAEgIAABIAAQASAgEAnwUCA1ICBQBSAwYAKwIBAJUEBAOMBQMAYAUHAAQAAAC7PwEDUgYBAKQFBQAAAEBAnwUCAoIFAgBIAOr/+wMAAIcCAwGCAgIABgMCAwMEAAAQQAIAAAAAAADwPwMIBAAAQEABAjAJARgAAAABAQEBAQAAAAAAAAAABAIDAAABAAAAAAD1EAAAMgAAAAAGAAABAgAeowAAAP8AAgAAAAAApAEBAAAAAEBvAwIAvAEBFgMAAACfAQMCpAIBAAAAAEBvBAQAvAICFgMAAACfAgMC/wMAAAAAAAD/BAAAAAAAAMAFBQASAAMAEgABADAFAOsGAAAAwAUHABIABAASAAIAMAUAswgAAACCAAIACQMKBAAAAEADCwMMAw0GAQMEBgMDCQIBAwEAARgAAQACAAAAAAABAAAAAAACAAIAAwAAAAAkAAAAABkBAAAAAASQ6GvRw0MCqCZUhtPcJAeQ4PB8paIsAdA=

-- https://lua.expert/
local t = {}
local Players = game:GetService("Players")
local UserService = game:GetService("UserService")
local t2 = {}
local t3 = {}

function t.FetchIcon(p1, p2, p3, p4) --[[ FetchIcon | Line: 12 | Upvalues: t2 (copy), Players (copy) ]]
	if not t2[p2] then
		t2[p2] = {}
	end

	if not t2[p2][p3] then
		t2[p2][p3] = {}
	end

	if not t2[p2][p3][p4] then
		local v1 = false
		local count = 0

		while not v1 do
			local ok, _ = pcall(function() --[[ Line: 27 | Upvalues: t2 (ref), p2 (copy), p3 (copy), p4 (copy), Players (ref) ]]
				t2[p2][p3][p4] = Players:GetUserThumbnailAsync(p2, p3, p4)
			end)

			if not ok then
				count = count + 1
			end

			if count > 3 then
				return ""
			end

			v1 = ok
		end
	end

	return t2[p2][p3][p4]
end
function t.FetchDisplayName(p1, p2) --[[ FetchDisplayName | Line: 48 | Upvalues: t3 (copy), UserService (copy) ]]
	if not t3[p2] then
		local v1 = false
		local count = 0

		while not v1 do
			local ok, _ = pcall(function() --[[ Line: 55 | Upvalues: t3 (ref), p2 (copy), UserService (ref) ]]
				local t = {}

				t[1] = tonumber(p2)
				t3[p2] = UserService:GetUserInfosByUserIdsAsync(t)[1].DisplayName
			end)

			if not ok then
				count = count + 1
			end

			if count > 3 then
				return tostring(p2)
			end

			v1 = ok
		end
	end

	return t3[p2]
end

return t