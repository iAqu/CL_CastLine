-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
if game:GetService("RunService"):IsServer() then
	return require(script.GameAnalytics)
else
	return require(script.GameAnalyticsClient)
end