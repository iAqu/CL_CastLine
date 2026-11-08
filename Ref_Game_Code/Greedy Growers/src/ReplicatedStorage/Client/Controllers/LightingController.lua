-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMQDUVuYWJsZU9uU3RhcnQORmluZEZpcnN0Q2hpbGQLR2V0Q2hpbGRyZW4GUGFyZW50CUtuaXRTdGFydARnYW1lB1BsYXllcnMKR2V0U2VydmljZRFSZXBsaWNhdGVkU3RvcmFnZQhMaWdodGluZwdyZXF1aXJlCFBhY2thZ2VzBEtuaXQQQ3JlYXRlQ29udHJvbGxlcgROYW1lEkxpZ2h0aW5nQ29udHJvbGxlcgACCAEBAAAAEPsBAABvAwAAvAEBAwEAAACfAQMCDgEJALwCAWgCAAAAnwICBGQCAwD7BwAAMAcGJAMAAABuAvz/AgAAAIIAAQAEAwEDAgMDAwQACwUBGAAAAAAAAgEAAAABAAD/AAQMAAAAAAYAAAECACOjAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEBAAAAAEBvAwQAvAEBFgMAAACfAQMCpAIBAAAAAEBvBAUAvAICFgMAAACfAgMCpAMHAAAAYEBNBAHmCAAAAE0EBHEJAAAAnwMCAk0EAw8KAAAA4gUNAJ8EAgLABQ4AEgACADAFBJkPAAAAggQCABADBgQAAABAAwcDCAMJAwoDCwQAAGBAAwwDDQMOAw8DEAgBCwwAAAAGAAMFAQABAAEYAAAAAAAAAAEAAAAAAAEAAAAAAAIAAAAAAAACAAAABAAAAAoBAAAAAAFyix30c8OJFy1ip/beNpXMApMKgEBPd/U=

-- https://lua.expert/
game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local v1 = require(ReplicatedStorage.Packages.Knit).CreateController({
	Name = "LightingController"
})

function v1.KnitStart(p1) --[[ KnitStart | Line: 11 | Upvalues: Lighting (copy) ]]
	local EnableOnStart = Lighting:FindFirstChild("EnableOnStart")

	if not EnableOnStart then
		return
	end

	for v1, v2 in EnableOnStart:GetChildren() do
		v2.Parent = Lighting
	end
end

return v1