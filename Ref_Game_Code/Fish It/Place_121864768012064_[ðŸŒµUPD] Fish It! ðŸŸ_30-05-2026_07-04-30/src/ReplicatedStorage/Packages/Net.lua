-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
if not RunService:IsStudio() then
	return require(script.Parent._Index["sleitnick_net@0.2.0"].net)
end
if RunService:IsServer() and ServerScriptService.Security.DisableClientAnticheatStudio.Value then
	return require(script.Parent._Index["sleitnick_net@0.2.0"]:WaitForChild("StudioNet"))
end
if RunService:IsClient() and script.Parent._Index["sleitnick_net@0.2.0"]:FindFirstChild("StudioNet") then
	return require(script.Parent._Index["sleitnick_net@0.2.0"].StudioNet)
else
	return require(script.Parent._Index["sleitnick_net@0.2.0"].net)
end