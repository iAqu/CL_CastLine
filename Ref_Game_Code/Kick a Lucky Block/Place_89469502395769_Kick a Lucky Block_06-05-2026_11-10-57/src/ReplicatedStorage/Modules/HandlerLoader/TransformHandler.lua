-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local TransformController = require(ReplicatedStorage.Modules.ControllerLoader.TransformController)
local t = {}
function TransformCharacter(p1, p2) --[[ TransformCharacter | Line: 18 | Upvalues: t (copy), TransformController (copy) ]]
	if t[p1.Name] then
		t[p1.Name]()
	end
	if p1 then
		t[p1.Name] = TransformController:TransformToBrainrot(p1, p2)
	end
end
function RevertCharacter(p1) --[[ RevertCharacter | Line: 28 | Upvalues: t (copy) ]]
	if t[p1.Name] then
		t[p1.Name]()
	end
end
function InitCleanupCon() --[[ InitCleanupCon | Line: 34 | Upvalues: Players (copy), t (copy) ]]
	Players.PlayerRemoving:Connect(function(p1) --[[ Line: 35 | Upvalues: t (ref) ]]
		if t[p1.Name] then
			t[p1.Name] = nil
		end
	end)
end
function InitConnections() --[[ InitConnections | Line: 42 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("Transformed"):Connect(TransformCharacter)
	Network.OnClientEvent("Reverted"):Connect(RevertCharacter)
end
function t._init(p1) --[[ _init | Line: 49 ]]
	InitCleanupCon()
	InitConnections()
end
return t