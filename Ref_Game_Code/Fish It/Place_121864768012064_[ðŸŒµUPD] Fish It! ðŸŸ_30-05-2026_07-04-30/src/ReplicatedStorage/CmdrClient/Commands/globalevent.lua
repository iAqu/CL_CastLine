-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultAdmin"
local t = {}
for v2, v3 in require(ReplicatedStorage.Events) do
	if v2:find("Admin") then
		table.insert(t, v2)
	end
end
return {
	Name = "globalEvent",
	Description = "Add global event",
	Aliases = { "globalEvent" },
	Group = v1,
	Args = {
		{
			Type = "string",
			Name = "Event Name",
			Description = "Name of global event: " .. table.concat(t, " | ")
		},
		{
			Type = "number",
			Name = "Duration",
			Description = "Event duration in minutes",
			Optional = true
		}
	}
}