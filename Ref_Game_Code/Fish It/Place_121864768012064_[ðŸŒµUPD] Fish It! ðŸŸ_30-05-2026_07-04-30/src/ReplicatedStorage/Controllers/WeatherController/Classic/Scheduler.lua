-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}
t.__index = t
local t2 = {}
local v1 = nil
local function ensureRunning() --[[ ensureRunning | Line: 20 | Upvalues: v1 (ref), RunService (copy), t2 (copy) ]]
	if not v1 then
		v1 = RunService.Heartbeat:Connect(function(p1_2) --[[ Line: 25 | Upvalues: t2 (ref), v1 (ref) ]]
			for i = #t2, 1, -1 do
				local v12 = t2[i]
				v12.elapsed = v12.elapsed + p1_2
				local v3 = math.clamp(v12.elapsed / v12.duration, 0, 1)
				if v12.step(v3, p1_2) or v3 >= 1 then
					if v12.finish then
						v12.finish()
					end
					t2[i] = t2[#t2]
					t2[#t2] = nil
				end
			end
			if #t2 ~= 0 or not v1 then
				return
			end
			v1:Disconnect()
			v1 = nil
		end)
	end
end
function t.add(p1, p2, p3) --[[ add | Line: 50 | Upvalues: t2 (copy), v1 (ref), RunService (copy) ]]
	local v12 = t2
	table.insert(v12, {
		elapsed = 0,
		duration = math.max(p1, 0.001),
		step = p2,
		finish = p3
	})
	if not v1 then
		v1 = RunService.Heartbeat:Connect(function(p1_2) --[[ Line: 25 | Upvalues: t2 (ref), v1 (ref) ]]
			for i = #t2, 1, -1 do
				local v12 = t2[i]
				v12.elapsed = v12.elapsed + p1_2
				local v3 = math.clamp(v12.elapsed / v12.duration, 0, 1)
				if v12.step(v3, p1_2) or v3 >= 1 then
					if v12.finish then
						v12.finish()
					end
					t2[i] = t2[#t2]
					t2[#t2] = nil
				end
			end
			if #t2 ~= 0 or not v1 then
				return
			end
			v1:Disconnect()
			v1 = nil
		end)
	end
end
function t.delay(p1, p2) --[[ delay | Line: 61 | Upvalues: t (copy) ]]
	t.add(p1, function() --[[ Line: 62 ]]
		return nil
	end, p2)
end
return t