-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	PolicyInfo = {},
	PolicyChanged = require(ReplicatedStorage.Shared.Packages.Signal).new()
}
function LoadPolicy() --[[ LoadPolicy | Line: 15 | Upvalues: PolicyService (copy), LocalPlayer (copy), t (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 16 | Upvalues: PolicyService (ref), LocalPlayer (ref) ]]
		return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer)
	end)
	if not v1 then
		for i = 1, 3 do
			task.wait(2)
			local v3, v4 = pcall(function() --[[ Line: 23 | Upvalues: PolicyService (ref), LocalPlayer (ref) ]]
				return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer)
			end)
			v1, v2 = v3, v4
			break
		end
		if not v1 then
			return
		end
	end
	t.PolicyInfo = v2
	t.PolicyChanged:Fire(v2)
end
function t._init() --[[ _init | Line: 41 ]]
	task.spawn(LoadPolicy)
end
return t