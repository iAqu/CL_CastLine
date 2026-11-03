-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Modules = {},
	ValidEvents = {
		"Mystery Block",
		"TrainingTime",
		"Stadium",
		"Disco",
		"Void",
		"Virus",
		"Hacker_P1",
		"Hacker_P2",
		"Hacker_P3"
	},
	FIXED_TIMES = {
		TrainingTime = 305.8,
		["Mystery Block"] = 1800,
		Hacker_P1 = 700,
		Hacker_P2 = 600
	}
}
if game:GetService("RunService"):IsClient() then
	for v1, v2 in script.Weathers:GetChildren() do
		if v2:IsA("ModuleScript") then
			t.Modules[v2.Name] = require(v2)
		end
	end
	function t.GetWeatherModule(p1, p2) --[[ GetWeatherModule | Line: 20 ]]
		if p1.Modules[p2] then
			return p1.Modules[p2]
		end
	end
end
return t