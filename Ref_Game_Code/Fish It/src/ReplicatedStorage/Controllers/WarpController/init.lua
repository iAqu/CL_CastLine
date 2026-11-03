-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.ZonePlus)
require(script.Internal.Types)
local Styles = require(script.Styles)
local v1 = Net:RemoteEvent("ReplicateWarp")
local v2 = Net:RemoteEvent("ReplicateCharacter")
local t = {}
function t.Start(p1) --[[ Start | Line: 17 | Upvalues: Observers (copy), v2 (copy), v1 (copy), t (copy) ]]
	Observers.observeCharacter(function(p1, p2) --[[ Line: 18 | Upvalues: v2 (ref), v1 (ref), t (ref) ]]
		local t2 = {}
		v2.OnClientEvent:Connect(function(p12, p2) --[[ Line: 21 | Upvalues: p1 (copy), t2 (copy) ]]
			if p2 ~= p1 then
				return
			end
			local v1 = t2[p12]
			if not v1 then
				return
			end
			v1:UnhideCharacter()
		end)
		local v12 = v1.OnClientEvent:Connect(function(p12, p22, p3, p4, p5) --[[ Line: 32 | Upvalues: p1 (copy), t (ref), p2 (copy), t2 (copy) ]]
			if p22 ~= p1 then
				return
			end
			local v1 = t:ActivateTeleport(p12, p5, p1, p2, p3, p4)
			if v1 then
				local function f2() --[[ Line: 42 | Upvalues: t2 (ref), p12 (copy) ]]
					t2[p12] = nil
				end
				v1:OnCanceled(f2)
				v1:OnDestroyed(f2)
				v1.Completed:Connect(f2)
				t2[p12] = v1
				v1:Teleport()
			end
		end)
		return function() --[[ Line: 54 | Upvalues: v12 (copy) ]]
			v12:Disconnect()
		end
	end)
end
function t.ActivateTeleport(p1, p2, p3, p4, p5, p6, p7) --[[ ActivateTeleport | Line: 60 | Upvalues: Styles (copy) ]]
	local v1 = Styles[p2]
	if v1 then
		return v1.new(p4, p5, p6, p7, p3)
	else
		print("No styles!")
	end
end
return t