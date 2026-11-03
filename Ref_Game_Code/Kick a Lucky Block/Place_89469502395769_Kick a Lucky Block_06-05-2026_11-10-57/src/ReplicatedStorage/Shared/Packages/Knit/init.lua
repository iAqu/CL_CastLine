-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
if RunService:IsServer() then
	return require(script.KnitServer)
else
	local KnitServer = script:FindFirstChild("KnitServer")
	if KnitServer and RunService:IsRunning() then
		KnitServer:Destroy()
	end
	return require(script.KnitClient)
end