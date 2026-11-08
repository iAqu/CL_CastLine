-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMPDkZpbmRGaXJzdENoaWxkB3JlcXVpcmUNR2V0SXRlbU1vZHVsZQRnYW1lEVJlcGxpY2F0ZWRTdG9yYWdlCkdldFNlcnZpY2UKUnVuU2VydmljZQhQYWNrYWdlcwxXYWl0Rm9yQ2hpbGQGU2hhcmVkBEluZm8HVXRpbGl0eQRLbml0DFJvbGxXZWlnaHRlZAVJdGVtcwACBgIBAAAHBAAABQIEAxIrAQIAxgIAAIICAgD7AgAAUgQBAKkFAQC8AgIDAAAAAJ8CBAIrAgIAxgMAAIIDAgCkAwIAAAAQQFIEAgCfAwICUgIDAIICAgADAwEDAgQAABBAABEDARgAAAACAAAAAAABAAABAAAAAAESAAAAAAsAAAECAD6jAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEBAAAAAEBvAwQAvAEBFgMAAACfAQMCbwQFALwCANMGAAAAnwIDAm8FBwC8AwDTBgAAAJ8DAwJvBggAvAQD0wYAAACfBAMCbwcJALwFA9MGAAAAnwUDAqQGCwAAAKBAbwkMALwHAtMGAAAAnwcDAJ8GAAKkBwsAAACgQG8KDQC8CAXTBgAAAJ8IAwCfBwACbwoHALwIANMGAAAAnwgDAm8KCAC8CAjTBgAAAJ8IAwJvCg4AvAgI0wYAAACfCAMC/wkBAAAAAADACg8AEgAIADAKCUkQAAAAggkCABEDBAQAAABAAwUDBgMHAwgDCQMKAwsDDAMCBAAAoEADDQMOAw8GAAMDAQABAAEYAAAAAAAAAAEAAAAAAAIAAAABAAAAAQAAAAEAAAACAAAAAAAAAgAAAAAAAAIAAAAAAAAAAAAAAAIAAgAAAAkBAAAAAAFmRa/fmvUmcmecZ6uYhEhpFl24q1SBxd4=

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Shared = ReplicatedStorage:WaitForChild("Shared")

Shared:WaitForChild("Info")

local Utility = Shared:WaitForChild("Utility")

require(Packages:WaitForChild("Knit"))
require(Utility:WaitForChild("RollWeighted"))

local Items = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("Items")

return {
	GetItemModule = function(p1, p2) --[[ GetItemModule | Line: 17 | Upvalues: Items (copy) ]]
		if not p2 then
			return nil
		end

		local v1 = Items:FindFirstChild(p2, true)

		if v1 then
			return require(v1)
		end

		return nil
	end
}