-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}
local v1 = nil
local v2 = 0
local function StartLoop() --[[ StartLoop | Line: 14 | Upvalues: v1 (ref), RunService (copy), v2 (ref), t (copy) ]]
	if not v1 then
		v1 = RunService.PreRender:Connect(function(p1) --[[ Line: 17 | Upvalues: v2 (ref), t (ref) ]]
			v2 = v2 + p1 * 0.5
			local _ = (math.sin(v2 * math.pi * 2) + 1) / 2
			for i, v in ipairs(t) do
				local v22 = v:GetAttribute("OriginalSequence")
				if v22 then
					local Keypoints = v22.Keypoints
					local v3 = #Keypoints
					local v4 = table.create(v3)
					for i2, v5 in ipairs(Keypoints) do
						v4[i2] = ColorSequenceKeypoint.new(v5.Time, (v5.Value:Lerp(Keypoints[i2 % v3 + 1].Value, (math.sin((v2 + (i2 - 1) / v3) * math.pi * 2) + 1) / 2)))
					end
					v.Color = ColorSequence.new(v4)
				end
			end
		end)
	end
end
local function StopLoop() --[[ StopLoop | Line: 48 | Upvalues: v1 (ref), v2 (ref) ]]
	if v1 then
		v1:Disconnect()
		v1 = nil
		v2 = 0
	end
end
local function RestoreGradient(p1) --[[ RestoreGradient | Line: 55 ]]
	local v1 = p1:GetAttribute("OriginalSequence")
	if v1 then
		p1.Color = v1
		p1:SetAttribute("OriginalSequence", nil)
	end
end
return {
	Add = function(p1) --[[ Add | Line: 67 | Upvalues: t (copy), v1 (ref), RunService (copy), v2 (ref) ]]
		for i, v in ipairs(t) do
			if v == p1 then
				return
			end
		end
		p1:SetAttribute("OriginalSequence", p1.Color)
		local v12 = t
		table.insert(v12, p1)
		if not v1 then
			v1 = RunService.PreRender:Connect(function(p1) --[[ Line: 17 | Upvalues: v2 (ref), t (ref) ]]
				v2 = v2 + p1 * 0.5
				local _ = (math.sin(v2 * math.pi * 2) + 1) / 2
				for i, v in ipairs(t) do
					local v22 = v:GetAttribute("OriginalSequence")
					if v22 then
						local Keypoints = v22.Keypoints
						local v3 = #Keypoints
						local v4 = table.create(v3)
						for i2, v5 in ipairs(Keypoints) do
							v4[i2] = ColorSequenceKeypoint.new(v5.Time, (v5.Value:Lerp(Keypoints[i2 % v3 + 1].Value, (math.sin((v2 + (i2 - 1) / v3) * math.pi * 2) + 1) / 2)))
						end
						v.Color = ColorSequence.new(v4)
					end
				end
			end)
		end
	end,
	Remove = function(p1) --[[ Remove | Line: 80 | Upvalues: t (copy), v1 (ref), v2 (ref) ]]
		for i, v in ipairs(t) do
			if v == p1 then
				local v12 = v:GetAttribute("OriginalSequence")
				if v12 then
					v.Color = v12
					v:SetAttribute("OriginalSequence", nil)
				end
				table.remove(t, i)
			else
				continue
			end
			break
		end
		if #t == 0 and v1 then
			v1:Disconnect()
			v1 = nil
			v2 = 0
		elseif #t == 0 then
		end
	end
}