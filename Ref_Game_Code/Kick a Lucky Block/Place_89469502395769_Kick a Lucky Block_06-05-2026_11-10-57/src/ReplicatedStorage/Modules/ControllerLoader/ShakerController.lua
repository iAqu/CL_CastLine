-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}
local t2 = {}
local v1 = nil
local v2 = 0
local function GetShakeID() --[[ GetShakeID | Line: 10 | Upvalues: v2 (ref) ]]
	v2 = v2 + 1
	return v2
end
local function startLoop() --[[ startLoop | Line: 15 | Upvalues: v1 (ref), RunService (copy), t2 (copy) ]]
	if not v1 then
		v1 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 17 | Upvalues: t2 (ref), v1 (ref) ]]
			for k, v in pairs(t2) do
				if t2[k].dead then
					t2[k] = nil
				end
				v.current = math.min(v.current * v.fadeInDecay ^ p1, v.magnitude)
				v.callback(CFrame.Angles(math.rad((math.random() * 2 - 1) * v.current * v.roughness), math.rad((math.random() * 2 - 1) * v.current * v.roughness), (math.rad((math.random() * 2 - 1) * v.current * v.roughness))))
			end
			if #t2 == 0 then
				v1:Disconnect()
				v1 = nil
			end
		end)
	end
end
function t.add(p1, p2, p3, p4) --[[ add | Line: 41 | Upvalues: v2 (ref), t2 (copy), v1 (ref), RunService (copy) ]]
	local t = {
		current = 0.01,
		dead = false,
		magnitude = p1,
		roughness = p2,
		fadeInDecay = math.max((p1 / 0.01) ^ (1 / p3), 0),
		callback = p4
	}
	v2 = v2 + 1
	t2[v2] = t
	if not v1 then
		v1 = RunService.Heartbeat:Connect(function(p1) --[[ Line: 17 | Upvalues: t2 (ref), v1 (ref) ]]
			for k, v in pairs(t2) do
				if t2[k].dead then
					t2[k] = nil
				end
				v.current = math.min(v.current * v.fadeInDecay ^ p1, v.magnitude)
				v.callback(CFrame.Angles(math.rad((math.random() * 2 - 1) * v.current * v.roughness), math.rad((math.random() * 2 - 1) * v.current * v.roughness), (math.rad((math.random() * 2 - 1) * v.current * v.roughness))))
			end
			if #t2 == 0 then
				v1:Disconnect()
				v1 = nil
			end
		end)
	end
	return function() --[[ Line: 55 | Upvalues: t (copy) ]]
		t.dead = true
	end
end
return t