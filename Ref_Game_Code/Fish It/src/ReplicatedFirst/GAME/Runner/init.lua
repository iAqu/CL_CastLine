-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Loader = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Loader"))
local function InitStart(p1) --[[ InitStart | Line: 10 | Upvalues: Loader (copy) ]]
	local v1 = Loader.LoadDescendants(p1, Loader.MatchesName("Controller$"))
	for v2, v3 in v1 do
		if typeof(v3.Init) == "function" then
			local v4, v5 = pcall(v3.Init, v3)
			if not v4 then
				task.spawn(error, (("[Init Error]: %*\nController: %*"):format(v5, v2)))
			end
		end
	end
	for v6, v7 in v1 do
		if typeof(v7.Start) == "function" then
			task.spawn(function() --[[ Line: 26 | Upvalues: v7 (copy), v6 (copy) ]]
				xpcall(v7.Start, function(p1) --[[ Line: 27 | Upvalues: v6 (ref) ]]
					error((("[Start Error]: %*\nController: %*}\nTrace back: %*"):format(p1, v6, (debug.traceback()))))
				end, v7)
			end)
		end
	end
end
return {
	Init = function(p1) --[[ Init | Line: 37 | Upvalues: InitStart (copy), ReplicatedStorage (copy) ]]
		require(script:WaitForChild("WaitForPlayerData"))()
		require(script:WaitForChild("BeforeInit"))()
		InitStart(ReplicatedStorage.Controllers)
		require(script:WaitForChild("AfterStart"))()
	end
}