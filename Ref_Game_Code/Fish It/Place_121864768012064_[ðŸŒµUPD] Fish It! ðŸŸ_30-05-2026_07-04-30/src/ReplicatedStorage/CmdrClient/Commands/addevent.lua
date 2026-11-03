-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultSeniorStaff"
local t = {}
for v2, v3 in require(ReplicatedStorage.Events) do
	if v2:find("Admin") == nil then
		table.insert(t, v2)
	end
end
return {
	Name = "addevent",
	Description = "Add server event",
	Aliases = { "add", "event", "weather", "addevent" },
	Group = v1,
	Args = {
		{
			Type = "string",
			Name = "Event Name",
			Description = "Name of server event: " .. table.concat(t, " | ")
		}
	}
}