-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
return {
	Execute = function(p1, p2, p3) --[[ Execute | Line: 8 | Upvalues: RunService (copy) ]]
		local v1 = 1 / p2
		local v2 = 0
		return RunService.Heartbeat:Connect(function(p1) --[[ Line: 12 | Upvalues: v2 (ref), v1 (copy), p3 (copy) ]]
			local v12 = os.clock()
			if not (v1 <= v12 - v2) then
				return
			end
			v2 = v12
			p3(v12, p1)
		end)
	end
}