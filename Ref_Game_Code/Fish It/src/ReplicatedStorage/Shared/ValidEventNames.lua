-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
for i, v in ipairs(ReplicatedStorage.Events:GetChildren()) do
	local v1 = v.Name
	if v1 ~= "Day" and v1 ~= "Night" then
		table.insert(t, v1)
	end
end
return t