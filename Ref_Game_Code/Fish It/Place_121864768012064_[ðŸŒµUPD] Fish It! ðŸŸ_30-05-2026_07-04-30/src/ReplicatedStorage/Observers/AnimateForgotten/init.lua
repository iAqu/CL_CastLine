-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local EntityCreator = require(script.EntityCreator)
Observers.observeTag("AnimateForgotten", function(p1) --[[ Line: 7 | Upvalues: EntityCreator (copy) ]]
	local v1 = p1.Parent.Parent:FindFirstChildWhichIsA("VehicleSeat") or p1.Parent:FindFirstChildWhichIsA("VehicleSeat")
	if v1 then
		local v3 = EntityCreator.new(p1.Name, p1)
		local v4 = v1:GetPropertyChangedSignal("AssemblyLinearVelocity"):Connect(function() --[[ Line: 16 | Upvalues: v1 (copy), v3 (copy) ]]
			local Magnitude = v1.AssemblyLinearVelocity.Magnitude
			print("Current mag:", Magnitude)
			if Magnitude > 20 then
				v3:SetState("Swim1")
			else
				v3:SetState("Idle")
			end
		end)
		local v5 = v1.Destroying:Once(function() --[[ Line: 27 | Upvalues: v3 (copy) ]]
			v3:Destroy()
		end)
		return function() --[[ Line: 31 | Upvalues: v4 (copy), v5 (copy) ]]
			v4:Disconnect()
			if not (v5 and v5.Connected) then
				return
			end
			v5:Disconnect()
		end
	end
end)
return {}