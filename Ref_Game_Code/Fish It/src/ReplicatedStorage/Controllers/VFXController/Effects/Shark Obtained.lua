-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local function EmitAll(p1) --[[ EmitAll | Line: 2 ]]
	local list = {}
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			table.insert(list, v)
		end
	end
	for i, v in ipairs(list) do
		local v1 = v:GetAttribute("EmitCount")
		local v2 = v:GetAttribute("EmitDelay")
		if v1 and v2 then
			task.delay(v2, function() --[[ Line: 15 | Upvalues: v (copy), v1 (copy) ]]
				v:Emit(v1)
			end)
			continue
		end
		if v1 then
			v:Emit(v1)
		end
	end
end
return function(p1) --[[ Line: 24 | Upvalues: EmitAll (copy) ]]
	local tri = p1:WaitForChild("tri")
	local Charge = p1:WaitForChild("Charge")
	local swirl = Charge:WaitForChild("swirl")
	local swirl_2 = Charge:WaitForChild("swirl")
	local Splash = p1:WaitForChild("Splash")
	swirl.Enabled = true
	swirl_2.Enabled = true
	task.wait(0.8)
	EmitAll(Charge)
	swirl.Enabled = false
	swirl_2.Enabled = false
	task.wait(0.25)
	EmitAll(Splash)
	tri:Emit(tri:GetAttribute("EmitCount") or 0)
end