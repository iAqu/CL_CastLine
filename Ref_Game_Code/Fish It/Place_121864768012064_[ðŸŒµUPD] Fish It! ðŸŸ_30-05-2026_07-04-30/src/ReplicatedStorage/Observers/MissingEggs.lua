-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local LocalPlayer = Players.LocalPlayer
local t = {}
Observers.observeTag("MissingEggs", function(p1) --[[ Line: 11 | Upvalues: t (copy) ]]
	local v1 = t
	table.insert(v1, p1)
	return function() --[[ Line: 14 | Upvalues: t (ref), p1 (copy) ]]
		table.remove(t, table.find(t, p1))
	end
end)
task.spawn(function() --[[ Line: 19 | Upvalues: LocalPlayer (copy), t (copy) ]]
	local EggIndicator = script:WaitForChild("EggIndicator")
	EggIndicator.Name = "EggIndicator"
	EggIndicator.Parent = LocalPlayer:WaitForChild("PlayerGui")
	while true do
		task.wait(0.5)
		if #t ~= 0 and LocalPlayer:GetAttribute("LocationName") == "Easter Island" then
			local Character = LocalPlayer.Character
			local v1 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
			if v1 then
				local v2 = true
				local v3 = nil
				for i, v in ipairs(t) do
					if v.Transparency > 0 then
						v2 = false
					end
				end
				if not v2 then
					local Position = v1.Position
					local v4 = 100
					for i, v in ipairs(t) do
						if v.Transparency ~= 0 then
							local Magnitude = (v.Position - Position).Magnitude
							if not (v4 < Magnitude) then
								v3 = v
								v4 = Magnitude
							end
						end
					end
				end
				if v3 then
					EggIndicator.Adornee = v3
				else
					EggIndicator.Adornee = nil
				end
				continue
			end
		end
		EggIndicator.Adornee = nil
	end
end)
return {}